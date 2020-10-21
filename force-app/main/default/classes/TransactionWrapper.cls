//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

/**
* Wrapper class for Transaction Details 
**/
public class TransactionWrapper {

	public class Keys {        
        public String TransactionID;
	}

	public class Values {        
        public String TotalCost;
        public String TotalDiscount;
		public Date TransactionDate;
        public String TotalCount;
	}

	public Keys keys;
	public Values values;

	
	public static List<TransactionWrapper> parse(String json) {
		return (List<TransactionWrapper>) System.JSON.deserialize(json, List<TransactionWrapper>.class);
	}
}