trigger AcknowledgeOpportunityTrigger on Task (after insert, after update) {
	for (Task t: Trigger.new) {
		if (t.Status == 'Completed') {
			Opportunity opp =[Select Name from Opportunity Where Id =: t.WhatId]; // probably not this part either.
			opp.Acknowledged__c = true;
			update opp; // not bulk friendly one bit
		}
	}
}