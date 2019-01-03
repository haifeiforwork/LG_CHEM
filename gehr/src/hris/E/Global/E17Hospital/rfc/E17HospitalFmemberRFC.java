package hris.E.Global.E17Hospital.rfc;

import hris.E.Global.E17Hospital.E17HospitalFnameData;
import hris.E.Global.E21Expense.E21ExpenseData1;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;

public class E17HospitalFmemberRFC extends SAPWrap {
	//private String functionName = "ZHR_RFC_FAMILY_ENAME_ALL";
	private String functionName = "ZGHR_RFC_FAMILY_ENAME_ALL";

	   public Vector getFname(String empNo) throws GeneralException {
	        JCO.Client mConnection = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName) ;

	            setInput(function, empNo);
	            excute(mConnection, function);
	            Vector ret = getTable(hris.E.Global.E17Hospital.E17HospitalFnameData.class, function, "T_ITAB");//getOutput(function);

	            return ret;
	        } catch(Exception ex){
	            //Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	   }

	   private void setInput(JCO.Function function, String empNo) throws GeneralException {
	        String fieldName = "I_PERNR";
	        setField( function, fieldName, empNo );
	    }

	    /**
	     * RFC 실행후 Export 값을 Vector 로 Return 한다.
	     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
	     * @param function com.sap.mw.jco.JCO.Function
	     * @return java.util.Vector
	     * @exception com.sns.jdf.GeneralException
	     */
	    private Vector getOutput(JCO.Function function) throws GeneralException {
	    	//String entityName = "hris.E.E17Hospital.E17HospitalFnameData";
	        //String tableName = "T_ITAB";      // RFC Export 구성요소 참조
	        return getTable(hris.E.Global.E17Hospital.E17HospitalFnameData.class, function, "T_ITAB");
	    }

	    public Vector getCodeVector(String empNo) throws GeneralException{
	        Vector retvt = new Vector();
	        try{
	        	Vector result = getFname(empNo);

	            for (int i = 0; i < result.size(); i++) {
	                com.sns.jdf.util.CodeEntity ret = new com.sns.jdf.util.CodeEntity();
	                E17HospitalFnameData fname = (E17HospitalFnameData)result.get(i);
	                ret.code = fname.FAMSA;
	                ret.value =fname.ENAME;
	                //Logger.debug.println(this, ret.toString());
	                DataUtil.fixNullAndTrim( ret );
	                retvt.addElement(ret);
	            }
	            Logger.debug.println(this, "************getCodeVector()  ...끝 ********* tableName : "+retvt );
	        } catch ( Exception ex ){
	            Logger.debug.println(this, "getCodeVector( JCO.Function function, String tableName)에서 예외발생 " );
	            throw new GeneralException(ex);
	        }
	        return retvt;
	    }



	    public Vector getCodeVector1(String empNo) throws GeneralException{
	        Vector retvt = new Vector();
	        try{
	        	Vector result = getFname(empNo);

	            for (int i = 0; i < result.size(); i++) {
	                E21ExpenseData1 ret = new E21ExpenseData1();
	                E17HospitalFnameData fname = (E17HospitalFnameData)result.get(i);
	                ret.code = fname.FAMSA;
	                ret.value =fname.ENAME;
	                ret.obj  = fname.OBJPS;
	                //Logger.debug.println(this, ret.toString());
	                DataUtil.fixNullAndTrim( ret );
	                retvt.addElement(ret);
	            }
	            Logger.debug.println(this, "************getCodeVector()  ...끝 ********* tableName : "+retvt );
	        } catch ( Exception ex ){
	            Logger.debug.println(this, "getCodeVector( JCO.Function function, String tableName)에서 예외발생 " );
	            throw new GeneralException(ex);
	        }
	        return retvt;
	    }


}
