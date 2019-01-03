package hris.E.E19Disaster.rfc;

import java.lang.reflect.Field;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.common.Utils;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;
import com.sap.mw.jco.*;

import hris.A.A17Licence.A17LicenceData;
import hris.E.E19Disaster.*;
import hris.E.E20Congra.*;
import hris.E.E20Congra.rfc.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * E19CongraRequestRFC.java
 * 경조금 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2001/12/20
 */
public class E19CongraRequestRFC extends ApprovalSAPWrap {

   // private String functionName = "ZHRW_RFC_DISASTER_REQUEST";
	 private String functionName = "ZGHR_RFC_DISASTER_REQUEST";

    /**
     * 경조금 조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */

    public Vector getDetail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);
            Vector T_RESULT = getOutput(function);

            return T_RESULT;

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
    public String build(  Vector<E19DisasterData> reportVector,E19CongcondData e19CongcondData, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            Logger.debug.println("재해신청서 size2----"+reportVector.size());
            // 재해피해신고서 입력여부  check
            if( Utils.getFieldValue(e19CongcondData,"CONG_CODE").equals("0005") && reportVector.size() < 1 ){
                Logger.debug.println(this,"재해피해신고서가 등록되지 않았습니다.");
                throw new BusinessException("재해피해신고서가 작성되지 않았습니다.");
            }
            Utils.setFieldValue(e19CongcondData, "WAGE_WONX", DataUtil.changeGlobalAmount((String) Utils.getFieldValue(e19CongcondData,"WAGE_WONX"), "KRW")) ;
            Utils.setFieldValue(e19CongcondData, "CONG_WONX", DataUtil.changeGlobalAmount((String) Utils.getFieldValue(e19CongcondData,"CONG_WONX"), "KRW")) ;

            setTable(function, "T_CONG_RESULT", Utils.asVector(e19CongcondData));

            if(   Utils.getFieldValue(e19CongcondData,"CONG_CODE").equals("0005") && reportVector.size() > 0 ) {
            	setTable(function, "T_DISA_RESULT", reportVector);
            }

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
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
 /*   public void change(  String keycode , Object congra, Vector reportVector, Vector applVector ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            E19CongcondData congra_data = (E19CongcondData)congra;

            // 재해피해신고서 입력여부  check
            if( congra_data.CONG_CODE.equals("0005") && reportVector.size() < 1 ){
                Logger.debug.println(this,"재해피해신고서가 등록되지 않았습니다.");
                throw new BusinessException("재해피해신고서가 작성되지 않았습니다.");
            }

            congra_data.WAGE_WONX = Double.toString(Double.parseDouble(congra_data.WAGE_WONX) / 100.0 ) ;  // 통상임금
            congra_data.CONG_WONX = Double.toString(Double.parseDouble(congra_data.CONG_WONX) / 100.0 ) ;  // 경조금

            Vector congraVector = new Vector();
            congraVector.addElement(congra_data);

            setInput(function, keycode, "3");

            setInput(function, congraVector, "T_CONG_RESULT");
            if(  congra_data.CONG_CODE.equals("0005") && reportVector.size() > 0 ) {
                setInput(function, reportVector, "T_DISA_RESULT");
            }
            setInput(function, applVector, "T_SETT_RESULT", "APPL_");

            excute(mConnection, function);

         } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }*/
    /**
     * 경조금 삭제 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */


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

    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {
        setTable(function, tableName, entityVector);
    }

    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        Vector CONG_RESULT = getTable(hris.E.E19Disaster.E19CongcondData.class, function, "T_CONG_RESULT");

        Vector DISA_RESULT = getTable(hris.E.E19Disaster.E19DisasterData.class, function, "T_DISA_RESULT");

        ret.addElement(CONG_RESULT);
        ret.addElement(DISA_RESULT);
        return ret ;
    }
}

