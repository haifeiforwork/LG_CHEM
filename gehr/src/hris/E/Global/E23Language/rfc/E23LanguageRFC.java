package hris.E.Global.E23Language.rfc;

import hris.E.Global.E23Language.E23LanguageData;
import hris.E.Global.E23Language.E23LanguageData3;
import hris.common.approval.ApprovalSAPWrap;

import java.io.Serializable;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.servlet.Box;

public class E23LanguageRFC extends ApprovalSAPWrap {
	//private String functionName = "ZHR_RFC_FAMILY_ENAME";
	//private String functionName1 = "ZHRH_RFC_LANG_FEE_REQUEST";
	private String functionName = "ZGHR_RFC_FAMILY_ENAME";
	private String functionName1 = "ZGHR_RFC_LANG_FEE_REQUEST";

	public Vector getLanguageDetail(String empNo,String I_type,String I_gbun,String I_code) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,I_type,I_gbun,I_code);

            excute(mConnection, function);

            Vector ret = null;
            ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	public Vector getLanguageDetail1(String empNo,String I_type,String I_gbun,String I_code,String objps) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput1(function, empNo,I_type,I_gbun,I_code,objps);

            excute(mConnection, function);

            Vector<Serializable> ret = null;
            //ret = getOutput1(function);
            ret = getTable( E23LanguageData.class,function, "T_ITAB");
            ret.addElement(getField("E_WAERS",function));
            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	public Vector getLanguageDetail2(String empNo,String I_type,String ainf_seqn ) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput(function, empNo, ainf_seqn ,I_type);

            excuteDetail(mConnection, function); //excute(mConnection, function);

            Vector ret = null;
            //ret = getOutput1(function);
            ret = getTable( E23LanguageData.class,function, "T_ITAB");

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	public Vector getDetail(String empNo ,String I_gbun) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput1(function, empNo,"1",I_gbun);

            excuteDetail(mConnection, function); //excute(mConnection, function);

            Vector ret = null;
            //ret = getOutput1(function);
            ret = getTable( E23LanguageData.class,function, "T_ITAB");

            return ret;
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}
    private void setInput1(JCO.Function function, String empNo,String I_type,String ainf_seqn) throws GeneralException {
        String fieldName1 = "I_ITPNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_GTYPE"            ;
        setField(function, fieldName2, I_type);
        String fieldName5 = "I_AINF_SEQN"            ;
        setField(function, fieldName5, ainf_seqn);
    }
	public String getLanguageName(String empNo,String I_type,String I_gbun,String I_code) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo,I_type,I_gbun,I_code);

            excute(mConnection, function);

            return getField("E_ENAME", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

	/**
     * 어학비(주재원) RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<E23LanguageData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            //String message =rfc.build(PERNR, "2", E23LData.PERS_GUBN, E23LData.OBJPS,	E23LanguageData);

            //Logger.debug.println(this, "====box.get(PERNR) ========= : " + box );

            setField(function, "I_ITPNR",  box.get("PERNR"));
            setField(function, "I_GTYPE", box.get("I_GTYPE"));
            setField(function, "I_PERS_GUBN", box.get("PERS_GUBN"));
            setField(function, "I_FAMI_CODE", box.get("FAMI_CODE"));
            setField(function, "I_OBJPS" , box.get("OBJPS"));

            setTable(function, "T_ITAB", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

	public String build(String empNo,String I_type,String I_gbun,String I_code,Vector tem) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput(function, empNo,I_type,I_gbun,I_code);

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

	public String build1(String empNo,String I_type,String I_gbun,String I_code,String I_objps,Vector tem) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput1(function, empNo,I_type,I_gbun, I_code,I_objps);

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

	public String change(String empNo,String I_type,String ainf_seqn,Vector tem) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput(function, empNo,ainf_seqn,I_type);

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

	public String delete(String empNo,String I_type,String ainf_seqn) throws GeneralException{
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            setInput(function, empNo,ainf_seqn,I_type);

            excute(mConnection, function);

            return getField("E_MESSAGE", function);
        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
	}

    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    private void setInput(JCO.Function function, String empNo,String I_type,String I_gbun,String I_code) throws GeneralException {
        String fieldName1 = "I_ITPNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_GTYPE"            ;
        setField(function, fieldName2, I_type);
        String fieldName3 = "I_PERS_GUBN"            ;
        setField(function, fieldName3, I_gbun);
        String fieldName4 = "I_FAMI_CODE"            ;
        setField(function, fieldName4, I_code);
    }

    private void setInput1(JCO.Function function, String empNo,String I_type,String I_gbun,String I_code,String objps) throws GeneralException {
        String fieldName1 = "I_ITPNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_GTYPE"            ;
        setField(function, fieldName2, I_type);
        String fieldName3 = "I_PERS_GUBN"            ;
        setField(function, fieldName3, I_gbun);
        String fieldName4 = "I_FAMI_CODE"            ;
        setField(function, fieldName4, I_code);
        String fieldName5 = "I_OBJPS"            ;
        setField(function, fieldName5, objps);
    }

    private void setInput(JCO.Function function, String empNo,String ainf_seqn,String I_type) throws GeneralException {
        String fieldName1 = "I_ITPNR"            ;
        setField(function, fieldName1, empNo);
        String fieldName2 = "I_GTYPE"            ;
        setField(function, fieldName2, I_type);
        String fieldName5 = "I_AINF_SEQN"            ;
        setField(function, fieldName5, ainf_seqn);
    }
    private Vector getOutput(JCO.Function function) throws GeneralException {

        Vector sum = new Vector();
        Vector pers=getCodeVector( function, "T_ITAB1");
        Vector sub=getCodeVector( function,  "T_ITAB2");
        Vector name=getTable( E23LanguageData3.class,function, "T_ITAB3");

        sum.addElement(pers);
        sum.addElement(sub);
        sum.addElement(name);
        return sum;
    }

    /**
     * 어학비 (주재원) 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName1) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            //Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}
