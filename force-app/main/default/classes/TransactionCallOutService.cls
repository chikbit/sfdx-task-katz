public class TransactionCallOutService {
    
    /**
	* Send asynchronously TransactionItem and Transaction data to external system     
	*/
    //@InvocableMethod(label='Callout POST Transaction & Transaction Items to Backend')    
    public static void postTransactionDetails(List<ID> transactionIDs) {
        if (!transactionIDs.isEmpty())
            //Retreive the id of Parent Transaction. 
            System.enqueueJob(new QueueableTransactionCall(transactionIDs.get(0)));
    }   
    
    /**
	* This method queues the HTTPCallouts for TransactionItem  first and then Transaction 
	* - On success of both transactions - Submission_Status__c in Transaction Object is updated 
	* as 'Submitted' 
	* - In case of failure of either transactions, Submission_Status__c in Transaction Object is updated 
	* as 'Resumbit'      
	*/
    public class QueueableTransactionCall implements Queueable, Database.AllowsCallouts {
        
        private Id transactionID;
        
        public QueueableTransactionCall(Id transactionID) {
            this.transactionID = transactionID;
        }
        
        public void execute(System.QueueableContext ctx) {
            
            String transactionJSON;
            
            // Get TransactionData as JSON String
            transactionJSON = JSONUtility.serializeTransactonItemData(transactionID);
            
            // create http request with all headers
            // Post Transaction Item data
            HttpRequest request = JSONUtility.createRequest(transactionJSON);
            // send
            HttpResponse response = new Http().send(request);            
            System.debug('response.getStatusCode()'  + response.getStatusCode());
            
            // if TransactionItem data POST successful, send Parent Transaction Details
            if (response.getStatusCode() == 201) {                
				//Get Transaction as JSON String
                transactionJSON = JSONUtility.serializeTransactonData(transactionID);
                request = JSONUtility.createRequest(transactionJSON);
                System.debug('response >>>'  + request);
                // send
                response = new Http().send(request);                
                System.debug('response >>>'  + response);
            }
            
            //Initialise the Transaction Object
            Transaction__c tr = new Transaction__c(Id = transactionID);
            
            if (response.getStatusCode() != 201) {
                // Update the status one of the callout failed
                tr.Submission_Status__c = JSONUtility.TRANSACTION_RESUBMIT_PROJECT;
                //@TODO - Imeplement EmailManager to notify of failure
                //@TODO - Implement Schedulable Class to resend the failed transactions (Submission_Status__c == Resubmit)
                //EmailManager.sendMail('youmetemp+delete@gmail.com', 'Transaction data for transaction ID', 
                //    transactionID + ' could not be sumbitted.');
            } else {
                // Update status as both callouts were sucessful
                TR.Submission_Status__c = JSONUtility.TRANSACTION_SUBMITTED_PROJECT;
            }
            update tr;
        }  
    }
}