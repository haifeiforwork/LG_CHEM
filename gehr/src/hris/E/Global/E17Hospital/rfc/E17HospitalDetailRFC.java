/********************************************************************************/
/*   System Name  	: g-HR
/*   Program Name 	:
/*   Program ID   		: E17HospitalDetailDataRFC
/*   Description  		:
/*   Note         		:
/*   Creation    		:
/*   Update				: 2009-05-22 jungin @v1.1 [C20090514_56175] 蹂댄뿕媛��엯 �뿬遺� 'ZINSU' �븘�뱶 異붽�.
/********************************************************************************/

package hris.E.Global.E17Hospital.rfc;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import hris.E.Global.E17Hospital.E17HospitalDetailData;
import hris.E.Global.E17Hospital.E17HospitalDetailData1;
import hris.common.approval.ApprovalSAPWrap;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;

public class E17HospitalDetailRFC extends ApprovalSAPWrap{
    //private String functionName = "ZHRW_RFC_MEDICAL_EXP_REQUEST";             //  ZHRS043S
    private String functionName = "ZGHR_RFC_MEDICAL_EXP_REQUEST";

    public Vector getMediData(String empNo, String I_INSUR, String ainf_seqn, String type, String cdate, String waers) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function,empNo, I_INSUR, ainf_seqn, type, cdate, waers);
            excute(mConnection, function);
            Vector sum = new Vector();
            E17HospitalDetailData ret = getOutput(function, new E17HospitalDetailData());
            sum.addElement(ret);
            sum.addElement(getField("E_WAERS", function));
            return sum;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector getMediDetail(String empNo, String I_INSUR, String ainf_seqn, String type) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, I_INSUR, ainf_seqn, type, "", "");

           //// excute(mConnection, function);    // 확인 .
            excuteDetail(mConnection, function);

            Vector ret = getTable( E17HospitalDetailData1.class,function, "T_ITAB"); //getOutput1(function);
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public Vector<E17HospitalDetailData1> getMediDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(E17HospitalDetailData1.class, function, "T_ITAB");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 의료비(주재원) RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E17HospitalDetailData1> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);

            setField(function, "I_ITPNR", box.get("PERNR"));
            setField(function, "I_INSUR", box.get("ZINSU"));
            //setField( function, "I_AINF_SEQN", ainf_seqn );
            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setField(function, "I_DATE", box.get("BEGDA"));
            setField(function, "I_WAERS", box.get("WAERS"));

            setTable(function, "T_ITAB", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 의료비(주재원) RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E17HospitalDetailData1> T_RESULT, Box box, HttpServletRequest req, Vector tem) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            //Logger.debug.println(this, "====box.get ========= : " + box );
            //setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);

            setField(function, "I_ITPNR", box.get("PERNR"));
            setField(function, "I_INSUR", box.get("ZINSU"));
            //setField( function, "I_AINF_SEQN", ainf_seqn );
            setField(function, "I_GTYPE",  box.get("I_GTYPE"));
            setField(function, "I_DATE", box.get("BEGDA"));
            setField(function, "I_WAERS", box.get("WAERS"));

			setField(function, "I_RTYPE", box.get("I_RTYPE"));			//2016.11.18

            setTable(function, "T_ITAB", T_RESULT);
            setTable(function, "T_FILE", tem);   //2016.11.18

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String build(String empNo, String I_INSUR, String ainf_seqn, String type, String cdate, String waers, Vector tem) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, I_INSUR, ainf_seqn, type, cdate, waers);
            setInput(function, tem, "T_ITAB");
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String change(String empNo, String I_INSUR, String ainf_seqn, Vector tem) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, I_INSUR, ainf_seqn, "3", "", "");
            setInput(function, tem, "T_ITAB");
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public String delete(String empNo, String I_INSUR, String ainf_seqn) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            setInput(function, empNo, I_INSUR, ainf_seqn, "4", "", "");
            excute(mConnection, function);
            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

   private void setInput(JCO.Function function, String empNo, String I_INSUR, String ainf_seqn, String type, String cdate, String waers) throws GeneralException {
        String fieldName = "I_ITPNR";
		setField( function, fieldName, empNo );
		String fieldName1 = "I_INSUR";
		setField( function, fieldName1, I_INSUR );
		String fieldName2 = "I_AINF_SEQN";
		setField( function, fieldName2, ainf_seqn );
		String fieldName3 = "I_GTYPE";
		setField( function, fieldName3, type );
		String fieldName4 = "I_DATE";
		setField( function, fieldName4, cdate );
		String fieldName5 = "I_WAERS";
        setField( function, fieldName5, waers );
    }

    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
	 * RFC 실행후 Export 값을 Vector 로 Return 한다.
	 * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
	 * @param function com.sap.mw.jco.JCO.Function
	 * @return java.util.Vector
	 * @exception com.sns.jdf.GeneralException
	 */
	private E17HospitalDetailData getOutput(JCO.Function function,E17HospitalDetailData data) throws GeneralException {

		E17HospitalDetailData returnData = new E17HospitalDetailData();
		try{
			returnData = (E17HospitalDetailData)getStructor(data, function, "S_ITAB");
	    }catch(GeneralException e){
	    	Logger.debug.println("A15CertiRFC.getOutput.(A15CertiData)getStructor(data, function, structureName) exception");
	    }
	    return returnData;
	}

	 /**
     * 의료비 (주재원) 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_RTYPE", "M" );

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}
