Requirements
-------------
Req 1 -  When a TransactionItem is added, updated or deleted, all related TransactionItems belonging to the same transaction must be sent to an external system .
Req 2 - Send related Transaction details to the same external system after successful callout of TransactionItems.
Req 3 - Trigger on TransactionItem will invoke callout process.

Technical Design Decisions
-------------------------
1. To track if a transaction and related transactionitem have been sent to external system, use a custom field 'Submission Status" on Transction object
2. If callout fails for any reason, Submission Status field will be updated with 'Resubmit' 
3. Batch process will resend all the Transactions having Submission Status as Resubmit (not in the scope of this task)

List of Artefacts
------------------
1. TransactionWrapper - Wrapper class for Transaction Details
2. TransactionItemWrapper - Wrapper class for TransactionItem Object
3. TransactionCallOutService - Send asynchronously TransactionItem and Transaction data to external system
4. TransactionItemTrigger
5. TransactionCallOutServiceMock - HttpCalloutMock for positive testing
6. TransactionCallOutServiceFailedMock - HttpCalloutMock for negative testing
7. TestTransactionItemTrigger - TestTransactionItemTrigger covers tests for TransactionItemTrigger, TransactionCallOutService
8. JSONUtility - This class contains reusable methods to generate JSON for HTTPRequest body
