/proc/webhook_send_roundstatus(var/status, var/extraData)
	var/list/query = list("status" = status)

	if(extraData)
		query.Add(extraData)

	webhook_send("roundstatus", query)

/proc/webhook_send_asay(var/ckey, var/message)
	var/list/query = list("ckey" = url_encode(ckey), "message" = url_encode(message))
	webhook_send("asaymessage", query)

/proc/webhook_send_ooc(var/ckey, var/message)
	var/list/query = list("ckey" = url_encode(ckey), "message" = url_encode(message))
	webhook_send("oocmessage", query)

/proc/webhook_send(var/method, var/data)
	if(!webhook_address || !webhook_key)
		world << "fuck you"
		return

	world << "passed"

	var/query[] = world.Export("[webhook_address]?key=[webhook_key]&method=[method]&data=[list2json(data)]")
	world << "sent [list2json(data)]"
	if(!query)
		world << "bad query"
	world << "HTTP Header:"
	for(var/V in query)
		world << "[V] = [query[V]]"
	world << "\n"

	var/F = query["CONTENT"]
	if(F)
		world << html_encode(file2text(F))