global virtual class MonexaElement {
	private DateTime time_retrieved = DateTime.now();
	global DateTime timeRetrieved {get { return time_retrieved; }}
}