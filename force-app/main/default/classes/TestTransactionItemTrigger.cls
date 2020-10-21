/**
* TestTransactionItemTrigger covers tests for
* - TransactionItemTrigger
* - TransactionCallOutService
**/
@isTest
public class TestTransactionItemTrigger {
    
    /**
* Transaction.Submission_Status__c field must be updated to 'Submitted' once 
* Transaction Items and Transaction details are posted   
**/
    @isTest
    static void testSuccess(){
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new TransactionCallOutServiceMock());
        Transaction__c tr = new Transaction__c();
        tr.Total_Cost__c = 100.00;
        tr.Total_Discount__c = 10.00;
        //tr.Transaction_Date__c = Date.today();
        tr.Transaction_Count__c = 3;
        
        insert tr;
        
        List<TransactionItem__c> trItemList = new List<TransactionItem__c>{
            new TransactionItem__c(Item_Cost__c=200.00, Name='TI-01', Transaction__C = tr.Id),
                new TransactionItem__c(Item_Cost__c=300.00, Name='TI-02', Transaction__C = tr.Id)        
                };
                    
                    insert trItemList;
        
        Test.stopTest();  
        
        List<TransactionItem__c> itemList = [Select ID, Name, Item_Cost__c, 
                                              Transaction__C from TransactionItem__c];
        
        Transaction__c tran = [Select ID, Submission_Status__c from Transaction__c where id = : tr.id ];
        
        for(TransactionItem__c item : itemList){
            if(item.Name == 'TI-01'){                
                System.assertEquals(200.00, item.Item_Cost__c);
                System.assertEquals(tr.id, item.Transaction__C);                  
                
            }
        }            
        
        System.assertEquals('Submitted', tran.Submission_Status__c);        
    }
    
    /**
* Transaction.Submission_Status__c field must be updated to 'Resubmit' if    
* Transaction Items or Transaction details are not successfully posted   
**/   
    @isTest
    static void testFailed(){
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new TransactionCallOutServiceFailedMock());
        Transaction__c tr = new Transaction__c();
        tr.Total_Cost__c = 100.00;
        tr.Total_Discount__c = 10.00;
        //tr.Transaction_Date__c = Date.today();
        tr.Transaction_Count__c = 3;
        
        insert tr;
        
        List<TransactionItem__c> trItemList = new List<TransactionItem__c>{
            new TransactionItem__c(Item_Cost__c=200.00, Name='TI-01', Transaction__C = tr.Id),
                new TransactionItem__c(Item_Cost__c=300.00, Name='TI-02', Transaction__C = tr.Id)        
                };
                    
                    insert trItemList;
        
        Test.stopTest();  
        
        List<TransactionItem__c> itemList = [Select ID, Name, Item_Cost__c, 
                                              Transaction__C from TransactionItem__c];
        
        Transaction__c tran = [Select ID, Submission_Status__c from Transaction__c where id = : tr.id ];
        
        for(TransactionItem__c item : itemList){
            if(item.Name == 'TI-01'){
                //System.assertEquals('TI-01', item.Item_Name__c);
                System.assertEquals(200.00, item.Item_Cost__c);
                System.assertEquals(tr.id, item.Transaction__C);                  
                
            }
        }            
        
        System.assertEquals('Resubmit', tran.Submission_Status__c);
        
    }  
    
}