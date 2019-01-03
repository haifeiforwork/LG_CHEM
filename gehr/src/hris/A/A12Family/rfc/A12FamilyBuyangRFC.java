package	hris.A.A12Family.rfc;

import com.common.RFCReturnEntity;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import hris.A.A12Family.A12FamilyBuyangData;
import hris.common.approval.ApprovalSAPWrap;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;

/**
 * A12FamilyBuyangRFC.java
 * 부양가족을 신청하는 RFC를 호출하는 Class
 *
 * @author 김도신
 * @version 1.0, 2002/01/30
 */
public class A12FamilyBuyangRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_FAM_BUYANG_REQ";

    /**
     * 개인의 부양가족 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<A12FamilyBuyangData> getFamilyBuyang() throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            excuteDetail(mConnection, function);

            return getTable(A12FamilyBuyangData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 부양가족 입력 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public String build(Vector<A12FamilyBuyangData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

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
     * 부양가족 수정 RFC 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException

    public String change(Vector<A12FamilyBuyangData> T_RESULT, Box box, HttpServletRequest req) throws GeneralException {

    JCO.Client mConnection = null;
    try{
    mConnection = getClient();
    JCO.Function function = createFunction(functionName) ;

    A12FamilyBuyangData data = (A12FamilyBuyangData)licence;

    Vector licenceVector = new Vector();
    licenceVector.addElement(data);

    setInput(function, seqn, "3");

    setInput(function, licenceVector, "TAB");

    excute(mConnection, function);

    } catch(Exception ex){
    Logger.sap.println(this, "SAPException : "+ex.toString());
    throw new GeneralException(ex);
    } finally {
    close(mConnection);
    }
    }*/

    /**
     * 부양가족 삭제 RFC 호출하는 Method
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