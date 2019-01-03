package hris.common.rfc;

import com.common.constant.Area;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.common.PersonData;
import hris.common.WebUserData;
import hris.common.approval.ApprovalHeader;

/**
 * ZGHR_RFC_PERSON_SINFO
 * ���� ���� �� �⺻ ����� ������ ������
 */
public class PersonInfoRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_PERSON_SINFO";

    public PersonInfoRFC() {
        super();
    }

    public PersonInfoRFC(SAPType sapType) {
        super(sapType);
    }




    public PersonData getPersonInfo(String I_PERNR, String I_ADDIF) throws GeneralException {

        JCO.Client mConnection = null;

        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", I_PERNR);
            setField(function, "I_ADDIF", I_ADDIF);

            excute(mConnection, function, null);

            return getStructor(PersonData.class, function, "S_SINFO", null);

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }


    /**
     * ���� ���� �� �⺻ ����� ������ ������
     * @param I_PERNR ���
     * @return ����� ����
     * @throws GeneralException
     */
    public PersonData getPersonInfo(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;

        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function, null);

            return getStructor(PersonData.class, function, "S_SINFO", null);

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public ApprovalHeader getApprovalHeader(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;

        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function, null);

            return getStructor(ApprovalHeader.class, function, "S_SINFO", "E_");

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public WebUserData setSessionUserData(PersonData personData, WebUserData user) {
        user.companyCode      = personData.E_BUKRS ;
        user.ename            = personData.E_ENAME ;
        user.e_orgtx          = personData.E_ORGTX ;
        user.e_is_chief       = personData.E_IS_CHIEF ;
        user.e_stras          = personData.E_STRAS ;
        user.e_locat          = personData.E_LOCAT ;
        user.e_regno          = personData.E_REGNO ;
        user.e_oversea        = personData.E_OVERSEA ;
        user.e_phone_num      = personData.E_PHONE_NUM ;
        user.e_trfar          = personData.E_TRFAR ;
        user.e_trfgr          = personData.E_TRFGR ;
        user.e_trfst          = personData.E_TRFST ;
        user.e_vglgr          = personData.E_VGLGR ;
        user.e_vglst          = personData.E_VGLST ;
        user.e_dat03          = personData.E_DAT02 ;
        user.e_persk          = personData.E_PERSK ;
        user.e_deptc          = personData.E_DEPTC ;
        user.e_retir          = personData.E_RETIR ;
        user.e_grup_numb      = personData.E_GRUP_NUMB ;
        user.e_gansa          = personData.E_GANSA ;          // 20030623 CYH �߰���.
        user.e_orgeh          = personData.E_ORGEH;           // 20050214 �߰���.
        user.e_representative = personData.E_REPRESENTATIVE;  // 20050214 �߰���.
        user.e_authorization  = personData.E_AUTHORIZATION;   // 20050214 �߰���.
        user.e_authorization2  = personData.E_AUTHORIZATION2;   // 20141125 �߰���. [CSR ID:2651528] �λ���� �߰� �� �޴���ȸ ��� ����

        user.e_objid          = personData.E_OBJID ;          // 20050412 �߰���.
        user.e_obtxt          = personData.E_OBJTX ;          // 20050412 �߰���.
        user.e_werks          = personData.E_WERKS ;          // 20050413 �߰���. �λ翵��(EC00 �̸� �ؿܹ���)
        user.e_recon          = personData.E_RECON ;          // 20050414 �߰���. ��������('D'-���'S'-��ȥ'Y'-����)
        user.e_reday          = personData.E_REDAY ;          // 20050414 �߰���. ��������
        user.e_mail           = personData.E_MAIL  ;          // 20050420 �߰�.
        user.e_timeadmin  = personData.E_TIMEADMIN;   // 20090622 �߰���.

        user.e_titel 				= personData.E_JIKWT;
        user.e_titl2 				= personData.E_JIKKT;
        user.e_area 				= personData.E_MOLGA;
        user.e_btrtl = personData.E_BTRTL;
        user.area = Area.fromMolga(user.e_area);
        user.e_jikkb 				= personData.E_JIKKB;

        return user;
    }
}

