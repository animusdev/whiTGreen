/client/verb/suggest(suggbug as text)
	set category = "OOC"
	set name = "Report a bug or sugest a feature/improvement"
	suggbug = sanitizeSQL(suggbug)
	suggestDBInsert(usr.ckey, suggbug)

/proc/suggestDBInsert(ckey, sugg)
	var/DBQuery/query_suggestions_insert = dbcon.NewQuery("INSERT INTO suggestion (ckey, sugg) VALUES ('[ckey]', '[sugg]')")
	query_suggestions_insert.Execute()

/client/verb/readsuggest()
	set category = "Debug"
	set name = ".readreports"
	set hidden = 1
	var/DBQuery/query_suggestions_select = dbcon.NewQuery("SELECT id, ckey, sugg FROM suggestion")
	query_suggestions_select.Execute()
	var/dat
	if(!check_rights())
		usr << "Missing permissions"
		return
	dat += {"
		<!DOCTYPE html>
		<html>
		<table>
		<tr><td>id</td><td>ckey</td><td>sugg</td><td>X</td></tr>"}
	while(query_suggestions_select.NextRow())
		dat += "<tr><td>[query_suggestions_select.item[1]]</td>"
		dat += "<td>[query_suggestions_select.item[2]]</td>"
		dat += "<td>[query_suggestions_select.item[3]]</td>"
		dat += "<td><a href='?deleteDB=[query_suggestions_select.item[1]]'>D</a></td></tr>"
	dat += "</table>"
	usr << browse(sanitize_russian(dat), "window=suggread;size=600x400")


proc/suggestDBDelete(var/id)
	if(!check_rights(R_DEBUG,0))
		usr << "Missing permissions."
		return
	var/DBQuery/query_suggestions_delete = dbcon.NewQuery("DELETE FROM suggestion WHERE id = [text2num(id)]")
	query_suggestions_delete.Execute()
	usr << "Deleted"