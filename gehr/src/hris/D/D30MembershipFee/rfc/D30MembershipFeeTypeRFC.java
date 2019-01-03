package hris.D.D30MembershipFee.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import hris.D.D15EmpPayInfo.D15EmpPayTypeData;
import hris.D.D30MembershipFee.D30MembershipFeeTypeData;
import hris.common.approval.ApprovalSAPWrap;

import java.util.Vector;


/**
 * D15EmpPayRFC.java
 * 지급/공제 조회/신청/수정/삭제 RFC 를 호출하는 Class
 *
 * @author 정진만
 * @version 1.0, 2016/10/6
 */
public class D30MembershipFeeTypeRFC extends ApprovalSAPWrap {

    private String functionName = "ZGHR_RFC_P_MEM_FEE_MGART_ENTRY" ;

    /**
     * 사원임금유형정보를 가져옴
     * @param I_YYYYMM
     * @param I_PERNR
     * @return
     * @throws GeneralException
     */
    public Vector<D15EmpPayTypeData> getMembershipType(String I_PERNR, String I_YYYYMM) throws GeneralException {

        JCO.Client mConnection = null;
        try{

            mConnection = getClient();
            JCO.Function function = createFunction( functionName ) ;

            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_YYYYMM", I_YYYYMM );

            excute( mConnection, function );

            return getTable(D30MembershipFeeTypeData.class, function, "T_RESULT");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
}


