package hris.D.D15EmpPayInfo.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;


/**
 * D15EmpPayRFC.java
 * 지급/공제 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 정진만
 * @version 1.0, 2016/10/6
 */
public class D15EmpPayTypeGlobalRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_P_PAYMENT_LGART_ENTRY" ;

    /**
     * 사원임금유형정보를 가져옴
     * @param I_YYYYMM
     * @param I_PERNR
     * @return
     * @throws GeneralException
     */
    public Vector<D15EmpPayTypeData> getEmpPayType(String I_PERNR, String I_YYYYMM) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_YYYYMM", I_YYYYMM );

            excute( mConnection, function );

            return getTable(D15EmpPayTypeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * 회비탭 활성화 여부
     * @param I_PERNR
     * @return
     * @throws GeneralException
     */
    public String enableMemberFee(String I_PERNR) throws GeneralException {
        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_YYYYMM", DataUtil.getCurrentYear() + DataUtil.getCurrentMonth());

            excute( mConnection, function );

            return getField("E_MEMBERFEE", function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


}


