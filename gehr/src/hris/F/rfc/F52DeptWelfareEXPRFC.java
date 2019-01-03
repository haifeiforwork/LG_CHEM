/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  :                                                     */
/*   Program Name :                                         */
/*   Program ID   : F52DeptWelfareEXPRFC                                           */
/*   Description  : get medical, tuition and language fee RFC                                         */
/*   Note         :                                                         */
/*   Creation     : 2007-10-11   zhouguangwen global e-hr update                */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import hris.F.F52DeptWelfareLanguageData;
import hris.F.F52DeptWelfareMedicalData;
import hris.F.F52DeptWelfareSchoolData;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * F52DeptWelfareEXPRFC
 *
 * @author  zhouguangwen
 * 2007-10-11
 */
public class F52DeptWelfareEXPRFC extends SAPWrap{

	//private String functionName1 = "ZHRA_RFC_GET_WELFARE_MEDICAL";    //medical fee
	//private String functionName2 = "ZHRA_RFC_GET_WELFARE_SCHRSHIP";   //tuition fee
	//private String functionName3 = "ZHRA_RFC_GET_WELFARE_LANGUAGE";   //language fee
	private String functionName1 = "ZGHR_RFC_GET_WELFARE_MEDICAL";    //medical fee
	private String functionName2 = "ZGHR_RFC_GET_WELFARE_SCHRSHIP";   //tuition fee
	private String functionName3 = "ZGHR_RFC_GET_WELFARE_LANGUAGE";   //language fee


	//get information about medical expenses
	//begin 1

	public Vector getDeptWelfareMedicalEXP(String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput1(function, i_orgeh, i_check, i_start, i_end);
            excute(mConnection, function);
			ret = getOutput1(function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

 private void setInput1(JCO.Function function, String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
        String fieldName3 = "I_BEGDA";
        setField(function, fieldName3, i_start);
        String fieldName4 = "I_ENDDA";
        setField(function, fieldName4, i_end);
    }


 private Vector getOutput1(JCO.Function function) throws GeneralException {
    	Vector ret = new Vector();

    	 String E_RETURN   = getReturn().MSGTY;
     	 String E_MESSAGE   = getReturn().MSGTX;

    	// Table 결과 조회
    	Vector T_EXPORT = getTable(F52DeptWelfareMedicalData.class,  function, "T_ITAB");

    	ret.addElement(E_RETURN);
    	ret.addElement(E_MESSAGE);
    	ret.addElement(T_EXPORT);

    	return ret;
    }

//end 1


//get information about school expenses
	//begin 2

	 public Vector getDeptWelfareSchoolEXP(String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {

	        JCO.Client mConnection = null;
	        Vector ret = null;
	        try{
	            mConnection = getClient();
	            JCO.Function function = createFunction(functionName2) ;

	            setInput2(function, i_orgeh, i_check, i_start, i_end);
	            excute(mConnection, function);
				ret = getOutput2(function);

	        } catch(Exception ex){
	            Logger.sap.println(this, "SAPException : "+ex.toString());
	            throw new GeneralException(ex);
	        } finally {
	            close(mConnection);
	        }
	        return ret;
	    }

	 private void setInput2(JCO.Function function, String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {
	        String fieldName  = "I_ORGEH";
	        setField(function, fieldName, i_orgeh);
	        String fieldName1 = "I_LOWERYN";
	        setField(function, fieldName1, i_check);
	        String fieldName3 = "I_BEGDA";
	        setField(function, fieldName3, i_start);
	        String fieldName4 = "I_ENDDA";
	        setField(function, fieldName4, i_end);
	    }


	 private Vector getOutput2(JCO.Function function) throws GeneralException {
	    	Vector ret = new Vector();

	    	String E_RETURN   = getReturn().MSGTY;
	     	String E_MESSAGE   = getReturn().MSGTX;

	    	// Table 결과 조회
	    	Vector T_EXPORT = getTable(F52DeptWelfareSchoolData.class,  function, "T_ITAB");

	    	ret.addElement(E_RETURN);
	    	ret.addElement(E_MESSAGE);
	    	ret.addElement(T_EXPORT);

	    	return ret;
	    }

//end 2



//		get information about language expenses
		//begin 3

		 public Vector getDeptWelfareLanguageEXP(String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {

		        JCO.Client mConnection = null;
		        Vector ret = null;
		        try{
		            mConnection = getClient();
		            JCO.Function function = createFunction(functionName3) ;

		            setInput3(function, i_orgeh, i_check, i_start, i_end);
		            excute(mConnection, function);
					ret = getOutput3(function);

		        } catch(Exception ex){
		            Logger.sap.println(this, "SAPException : "+ex.toString());
		            throw new GeneralException(ex);
		        } finally {
		            close(mConnection);
		        }
		        return ret;
		    }

		 private void setInput3(JCO.Function function, String i_orgeh, String i_check, String i_start, String i_end) throws GeneralException {
		        String fieldName  = "I_ORGEH";
		        setField(function, fieldName, i_orgeh);
		        String fieldName1 = "I_LOWERYN";
		        setField(function, fieldName1, i_check);
		        String fieldName3 = "I_BEGDA";
		        setField(function, fieldName3, i_start);
		        String fieldName4 = "I_ENDDA";
		        setField(function, fieldName4, i_end);
		    }


		 private Vector getOutput3(JCO.Function function) throws GeneralException {
		    	Vector ret = new Vector();

		    	String E_RETURN   = getReturn().MSGTY;
		     	String E_MESSAGE   = getReturn().MSGTX;

		    	// Table 결과 조회
		    	Vector T_EXPORT = getTable(F52DeptWelfareLanguageData.class,  function, "T_ITAB");

		    	ret.addElement(E_RETURN);
		    	ret.addElement(E_MESSAGE);
		    	ret.addElement(T_EXPORT);

		    	return ret;
		    }

//	end 3


}
