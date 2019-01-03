package hris.E.E17Hospital.rfc ;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.DataUtil;
import hris.E.E17Hospital.E17BillData;
import hris.E.E17Hospital.E17HospitalData;
import hris.E.E17Hospital.E17HospitalResultData;
import hris.E.E17Hospital.E17SickData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;

/**
 * E17HospitalRFC.java
 *  사원의 의료비 신청/신청조회/신청수정/삭제를 수행하는 RFC를 호출하는 Class
 *
 * @author 김성일
 * @version 1.0, 2002/01/08
 */
public class E17HospitalRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_MEDIC_LIST" ;


    /**
     * 의료비 신청조회 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public E17HospitalResultData detail() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            E17HospitalResultData resultData = new E17HospitalResultData();

            resultData.T_ZHRA006T = getTable(E17SickData.class, function, "T_ZHRA006T");
            resultData.T_ZHRW005A = getTable(E17HospitalData.class, function, "T_ZHRW005A");
            resultData.T_ZHRW006A = getTable(E17BillData.class, function, "T_ZHRW005A");

            for(E17SickData data :  resultData.T_ZHRA006T) {
                data.COMP_WONX = DataUtil.changeLocalAmount(data.COMP_WONX, data.WAERS);
                data.YTAX_WONX = DataUtil.changeLocalAmount(data.YTAX_WONX, data.WAERS);
            }
            for(E17HospitalData data :  resultData.T_ZHRW005A){
                data.EMPL_WONX = DataUtil.changeLocalAmount(data.EMPL_WONX, data.WAERS);
                data.YTAX_WONX = DataUtil.changeLocalAmount(data.YTAX_WONX, data.WAERS);
            }
            for(E17BillData data :  resultData.T_ZHRW006A){
                data.TOTL_WONX = DataUtil.changeLocalAmount(data.TOTL_WONX, data.WAERS);
                data.ASSO_WONX = DataUtil.changeLocalAmount(data.ASSO_WONX, data.WAERS);
                data.EMPL_WONX = DataUtil.changeLocalAmount(data.EMPL_WONX, data.WAERS);
                data.MEAL_WONX = DataUtil.changeLocalAmount(data.MEAL_WONX, data.WAERS);
                data.APNT_WONX = DataUtil.changeLocalAmount(data.APNT_WONX, data.WAERS);
                data.ROOM_WONX = DataUtil.changeLocalAmount(data.ROOM_WONX, data.WAERS);
                data.CTXX_WONX = DataUtil.changeLocalAmount(data.CTXX_WONX, data.WAERS);
                data.MRIX_WONX = DataUtil.changeLocalAmount(data.MRIX_WONX, data.WAERS);
                data.SWAV_WONX = DataUtil.changeLocalAmount(data.SWAV_WONX, data.WAERS);
                data.DISC_WONX = DataUtil.changeLocalAmount(data.DISC_WONX, data.WAERS);
                data.ETC1_WONX = DataUtil.changeLocalAmount(data.ETC1_WONX, data.WAERS);
                data.ETC2_WONX = DataUtil.changeLocalAmount(data.ETC2_WONX, data.WAERS);
                data.ETC3_WONX = DataUtil.changeLocalAmount(data.ETC3_WONX, data.WAERS);
                data.ETC4_WONX = DataUtil.changeLocalAmount(data.ETC4_WONX, data.WAERS);
                data.ETC5_WONX = DataUtil.changeLocalAmount(data.ETC5_WONX, data.WAERS);
            }


            resultData.E_LASTDAY  = getField("E_LASTDAY",  function);  // 동일질병 마지막 신청일
            resultData.E_YEARS  = getField("E_YEARS",  function);  // 나이 년수
            resultData.E_MNTH  = getField("E_LASTDAY",  function);  // 나이 월수

            return resultData;

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 의료비 신청 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */

    public String build(E17HospitalResultData inputData, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            for(E17HospitalData data :  inputData.T_ZHRW005A){
                data.EMPL_WONX = DataUtil.changeGlobalAmount(data.EMPL_WONX, data.WAERS);
                //change 일 경우 아래 해제?
                data.YTAX_WONX = DataUtil.changeGlobalAmount(data.YTAX_WONX, data.WAERS);
            }
            for(E17BillData data :  inputData.T_ZHRW006A){
                data.TOTL_WONX = DataUtil.changeGlobalAmount(data.TOTL_WONX, data.WAERS);
                data.ASSO_WONX = DataUtil.changeGlobalAmount(data.ASSO_WONX, data.WAERS);
                data.EMPL_WONX = DataUtil.changeGlobalAmount(data.EMPL_WONX, data.WAERS);
                data.MEAL_WONX = DataUtil.changeGlobalAmount(data.MEAL_WONX, data.WAERS);
                data.APNT_WONX = DataUtil.changeGlobalAmount(data.APNT_WONX, data.WAERS);
                data.ROOM_WONX = DataUtil.changeGlobalAmount(data.ROOM_WONX, data.WAERS);
                data.CTXX_WONX = DataUtil.changeGlobalAmount(data.CTXX_WONX, data.WAERS);
                data.MRIX_WONX = DataUtil.changeGlobalAmount(data.MRIX_WONX, data.WAERS);
                data.SWAV_WONX = DataUtil.changeGlobalAmount(data.SWAV_WONX, data.WAERS);
                data.DISC_WONX = DataUtil.changeGlobalAmount(data.DISC_WONX, data.WAERS);
                data.ETC1_WONX = DataUtil.changeGlobalAmount(data.ETC1_WONX, data.WAERS);
                data.ETC2_WONX = DataUtil.changeGlobalAmount(data.ETC2_WONX, data.WAERS);
                data.ETC3_WONX = DataUtil.changeGlobalAmount(data.ETC3_WONX, data.WAERS);
                data.ETC4_WONX = DataUtil.changeGlobalAmount(data.ETC4_WONX, data.WAERS);
                data.ETC5_WONX = DataUtil.changeGlobalAmount(data.ETC5_WONX, data.WAERS);

            }

            setTable(function, "T_ZHRA006T", inputData.T_ZHRA006T);
            setTable(function, "T_ZHRW005A", inputData.T_ZHRW005A);
            setTable(function, "T_ZHRW006A", inputData.T_ZHRW006A);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 의료비 삭제 RFC 호출하는 Method
     * @return java.util.Vector
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
}




