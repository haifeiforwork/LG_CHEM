package hris.E.E19Congra.rfc;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E19Congra.E19CongcondData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;

/**
 * E19CongraRequestRFC.java
 * 경조금 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/20
 */
public class E19CongraRequestRFC extends ApprovalSAPWrap {

   // private String functionName = "ZHRW_RFC_CONGCOND_REQUEST";
	 private String functionName = "ZGHR_RFC_CONGCOND_REQUEST";

    /**
     * 경조금 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
 /*   public Vector detail( String keycode ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, "1");
            excute(mConnection, function);
            Vector ret = getOutput(function);
            Vector E19CongcondData_vt  = (Vector)ret.get(0);
            for( int i = 0 ; i < E19CongcondData_vt.size() ; i++ ){
                E19CongcondData data = (E19CongcondData)E19CongcondData_vt.get(i);
                data.WAGE_WONX = Double.toString(Double.parseDouble(data.WAGE_WONX) * 100.0) ;  // 통상임금
                data.CONG_WONX = Double.toString(Double.parseDouble(data.CONG_WONX) * 100.0) ;  // 경조금
            }

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    */

    public Vector<E19CongcondData> getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            E19CongcondData e19CongcondData =(E19CongcondData)getTable(E19CongcondData.class, function, "T_CONG_RESULT").get(0);

            Utils.setFieldValue(e19CongcondData, "WAGE_WONX", DataUtil.changeLocalAmount((String) Utils.getFieldValue(e19CongcondData,"WAGE_WONX"), "KRW")) ;
            Utils.setFieldValue(e19CongcondData, "CONG_WONX", DataUtil.changeLocalAmount((String) Utils.getFieldValue(e19CongcondData,"CONG_WONX"), "KRW")) ;

            return Utils.asVector(e19CongcondData);
        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 경조금 신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    /*public void build(String keycode, Object congra, Vector applVector, String companyCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E19CongcondData congra_data = (E19CongcondData)congra;

            congra_data.WAGE_WONX = Double.toString(Double.parseDouble(congra_data.WAGE_WONX) / 100.0 ) ;  // 통상임금
            congra_data.CONG_WONX = Double.toString(Double.parseDouble(congra_data.CONG_WONX) / 100.0 ) ;  // 경조금

            Vector congraVector = new Vector();
            congraVector.addElement(congra_data);

            setInput(function, keycode, "2");

            setInput(function, congraVector, "CONG_RESULT");

            setInput(function, applVector, "SETT_RESULT", "APPL_");

            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }*/

    public String build(E19CongcondData e19CongcondData, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;
            Utils.setFieldValue(e19CongcondData, "WAGE_WONX", DataUtil.changeGlobalAmount((String) Utils.getFieldValue(e19CongcondData,"WAGE_WONX"), "KRW")) ;
            Utils.setFieldValue(e19CongcondData, "CONG_WONX", DataUtil.changeGlobalAmount((String) Utils.getFieldValue(e19CongcondData,"CONG_WONX"), "KRW")) ;

            setTable(function, "T_CONG_RESULT", Utils.asVector(e19CongcondData));

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 경조금 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public void change(String keycode, Object congra, Vector applVector, String companyCode) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E19CongcondData congra_data = (E19CongcondData)congra;

            congra_data.WAGE_WONX = Double.toString(Double.parseDouble(congra_data.WAGE_WONX) / 100.0 ) ;  // 통상임금
            congra_data.CONG_WONX = Double.toString(Double.parseDouble(congra_data.CONG_WONX) / 100.0 ) ;  // 경조금

            Vector congraVector = new Vector();
            congraVector.addElement(congra_data);

            setInput(function, keycode, "3");

            setInput(function, congraVector, "CONG_RESULT");

            setInput(function, applVector, "SETT_RESULT", "APPL_");

            excute(mConnection, function);

         } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
    /**
     * 경조금 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
   /* public void delete(  String keycode  ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, keycode, "4");
            excute(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }*/

    public RFCReturnEntity delete() throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            return executeDelete(mConnection, function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param keycode java.lang.String 결재정보 일련번호
     * @param job java.lang.String 기능정보
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String keycode, String job) throws GeneralException {
        String fieldName = "I_AINF_SEQN";
        setField( function, fieldName, keycode );
        String fieldName2 = "I_CONT_TYPE";
        setField( function, fieldName2, job );
    }

// Import Parameter 가 Vector(Table) 인 경우
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param entityVector java.util.Vector
     * @param tableName java.util.Vector
     * @param prev java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, Vector entityVector, String tableName, String prev ) throws GeneralException {
        setTable(function, tableName, entityVector, prev);
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        Vector CONG_RESULT = getTable(E19CongcondData.class, function, "T_CONG_RESULT");

        ret.addElement(CONG_RESULT);

        return ret ;
    }
}


