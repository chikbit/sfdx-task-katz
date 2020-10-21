/*
* This class contains reusable methods to generate JSON for HTTPRequest body
*/
public class JSONUtility {
    
    public static String TRANSACTION_SUBMITTED_PROJECT = 'Submitted';
    public static String TRANSACTION_RESUBMIT_PROJECT = 'Resubmit';
    
    /**
	* The utility method serializes Transaction Item Data using 
	* Wrapper Class TransactionItemWrapper
	**/
    public static String serializeTransactonItemData(ID transID) {          
        
        String jsonString;
        
        // use wrapper class to send the data in a particular structure
        List<TransactionItemWrapper> wrList = new List<TransactionItemWrapper>(); 
        
        for (TransactionItem__c item : [SELECT Id,Item_Cost__c,Name FROM TransactionItem__c where Transaction__r.id =: transID]) {
            
            TransactionItemWrapper wr = new TransactionItemWrapper();
            TransactionItemWrapper.Keys keys = new TransactionItemWrapper.Keys();
            keys.TransactionItemID = item.id;  
            
            TransactionItemWrapper.Values values = new TransactionItemWrapper.Values(); 
            values.ItemCost = String.valueOf(item.Item_Cost__c);
            values.ItemName = item.Name;                 
            
            wr.keys = keys;
            wr.values = values;
            wrList.add(wr);
        }                          
        
        jsonString =  System.JSON.serialize(wrList);
        System.debug(' Json String >>>>>>>>>' + jsonString);		 
        return jsonString; 
    }
    
    /**
	* This utility method serializes Parent Transaction Data using 
	* Wrapper Class TransactionWrapper
	**/
    public static String serializeTransactonData(ID transID) {  
        
        String jsonString;         	
        TransactionWrapper wr = new TransactionWrapper();
        
        for (Transaction__c tran : [SELECT Id, Total_Cost__c, Total_Discount__c, CreatedDate, Transaction_Count__c FROM Transaction__c where id =: transID]) {        		
            
            TransactionWrapper.Keys keys = new TransactionWrapper.Keys();
            keys.TransactionID = tran.id;  
            
            TransactionWrapper.Values values = new TransactionWrapper.Values(); 
            values.TotalCost = String.valueOf(tran.Total_Cost__c) ;
            values.TotalDiscount = String.valueOf(tran.Total_Discount__c);            
            values.TransactionDate = getDate(tran.CreatedDate);
            values.TotalCount = String.valueOf(tran.Transaction_Count__c);                
            
            wr.keys = keys;
            wr.values = values;            	
        }                          
        
        jsonString =  System.JSON.serialize(wr);
        System.debug(' Json String >>>>>>>>>' + jsonString);		 
        return jsonString;
    }
    
    /**
	* For reusability of generic HTTPRequest creation, moved to this Utility class 
	**/    
    Public static HttpRequest createRequest(String JSONdata) {        
        
        HttpRequest request = new HttpRequest();
        
        // In absence of EndURL, using this service used in Trailhead practices
        // It provides basic HTTP sucess/fail msg.
        // Actual implementation will use Named Credentials, for this assignment, I am using RemoteSite Settigs                
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        
        request.setMethod('POST');        
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSONdata);       
        
        return request;
    }
    
    // convert from DateTime to Date
    public static Date getDate(DateTime dt){        
         return Date.newinstance(dT.year(), dT.month(), dT.day());
    }
}