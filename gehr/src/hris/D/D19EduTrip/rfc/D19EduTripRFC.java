package	hris.D.D19EduTrip.rfc;

import java.util.*;

import javax.servlet.http.HttpServletRequest;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.util.*;

import hris.A.A17Licence.A17LicenceData;
import hris.D.D19EduTrip.*;
import hris.common.approval.ApprovalSAPWrap;

/**
 * D19EduTripRFC.java
 * 개인의 교육, 출장신청 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author lsa
 * @version 1.0, 2006/08/08
 */
public class D19EduTripRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_ATTD_APPLY";

    /**
     * 개인의 교육, 출장신청 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<D19EduTripData> getVocation() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(D19EduTripData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * 교육, 출장신청 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */


    public String build(Vector<D19EduTripData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setTable(function, "T_RESULT", T_RESULT);

            return executeRequest(mConnection, function, box, req);

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 교육, 출장신청 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @param companyCode java.lang.String 회사코드
     * @exception com.sns.jdf.GeneralException
     */
    public String change(Vector<D19EduTripData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

    	 JCO.Client mConnection = null;
         try{
             mConnection = getClient();
             JCO.Function function = createFunction(functionName) ;

             setTable(function, "T_RESULT", T_RESULT);

             return executeChange(mConnection, function, box, req);

         } catch(Exception ex){
             Logger.error(ex);
             throw new GeneralException(ex);
         } finally {
             close(mConnection);
         }
    }

    /**
     * 교육, 출장신청 삭제 RFC 호출하는 Method
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
}