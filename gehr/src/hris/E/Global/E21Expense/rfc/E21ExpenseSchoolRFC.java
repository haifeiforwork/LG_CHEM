package hris.E.Global.E21Expense.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

public class E21ExpenseSchoolRFC extends SAPWrap  {
	//private String functionName = "ZHR_RFC_REIMBURSE_SCHOOL_TYPE";
	private String functionName = "ZGHR_RFC_REIMBURSE_SCHOOL_TYPE";

	public Vector display( String empNo,String subty ) throws GeneralException {
		JCO.Client mConnection = null;
		try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName);
	            setInput(function,empNo,subty);
	            excute(mConnection, function);
	            return getOutput(function);
	    } catch(Exception ex){
	        //Logger.sap.println(this, "SAPException : "+ex.toString());
	        throw new GeneralException(ex);
	    } finally {
	        close(mConnection);
	    }
	}

	 private void setInput(JCO.Function function,String empNo,String subty) throws GeneralException {
	        String fieldName = "I_PERNR";
	        setField( function, fieldName, empNo );
	        String fieldName1 = "I_SUBTY";
	        setField( function, fieldName1, subty );
	 }

	private Vector getOutput(JCO.Function function) throws GeneralException {
        //String tableName  = "ITAB1";
        //String tableName1  = "ITAB2";
        Vector sum = new Vector();
        Vector school = getCodeVector( function, "T_ITAB1");
        Vector stype  = getCodeVector( function, "T_ITAB2");
        sum.addElement(school);
        sum.addElement(stype);
	    return  sum;
	}
}
