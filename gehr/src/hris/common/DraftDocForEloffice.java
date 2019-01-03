/*
 * �ۼ��� ��¥: 2005. 2. 2.
 *
 */
package hris.common;

import com.sns.jdf.*;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;
import hris.G.ApprovalDocumentState;
import hris.G.rfc.ApprovalDocumentStateRFC;
import hris.common.approval.ApprovalLineData;
import org.apache.commons.lang.math.NumberUtils;

import java.util.Vector;

/**
 * @author �̽���
 *
 */
public class DraftDocForEloffice
{
    String parameters[] = { "APP_ID" ,"CATEGORY" ,"SUBJECT" ,"MAIN_STATUS","SUB_STATUS","REQ_DATE",
    		"EXPIRE_DATE","AUTH_DIV","AUTH_EMP","URL" ,"MODIFY","F_AGREE","R_EMP_NO","A_EMP_NO" };

    public ElofficInterfaceData init(String AINF_SEQN ,String SServer ,String UPMU_NAME) throws ConfigurationException, GeneralException
    {
        Config conf  = new Configuration();
        ElofficInterfaceData oef = new ElofficInterfaceData();

        oef.CATEGORY= UPMU_NAME; //��ĸ�
        oef.MAIN_STATUS="";//���� Main����
        oef.P_MAIN_STATUS="";
        oef.SUB_STATUS= "";//���� Sub����
        oef.REQ_DATE=   DataUtil.getCurrentDate()+DataUtil.getCurrentTime().substring(0,4);//��û��
        oef.EXPIRE_DATE="";//��������
        oef.AUTH_DIV=   "";//�����Һμ�
        oef.AUTH_EMP=   "";//�����Ұ���
        oef.MODIFY=     "";//��������
        oef.F_AGREE=    "";//�ڵ�����
        oef.R_EMP_NO=   "";//����ڻ��
        oef.A_EMP_NO=   "";//�����ڻ��
        oef.SUBJECT=UPMU_NAME;//�������
        oef.APP_ID=AINF_SEQN;//���繮��ID
        oef.URL="http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.ESBApprovalAutoLoginSV?AINF_SEQN="+AINF_SEQN+"&isNotApp=false";
        oef.DUMMY1=""; // ����ϰ����߰� ��C20110620_07375
        oef.TEMP = "http://"+conf.getString("com.sns.jdf.eloffice.ResponseURL")+WebUtil.ServletURL+"hris.MobileDetailSV?apprDocID="+AINF_SEQN; //��C20110620_07375

        return oef;
    }

    // ���� ���� ����
    public ElofficInterfaceData makeDocForRemove(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String PERNR ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = init(AINF_SEQN ,SServer ,UPMU_NAME);

        oef.MAIN_STATUS="R" ;
        oef.MODIFY="D" ;
        oef.R_EMP_NO=convertRealToTest(PERNR) ;
        oef.A_EMP_NO=convertRealToTest(APPU_NUMB) ;
        oef.SUB_STATUS="����" ;

        return oef;
    }

    // ������ ����
    public ElofficInterfaceData makeDocForChange(String AINF_SEQN ,String SServer,String PERNR ,String UPMU_NAME ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);

        oef.MAIN_STATUS="R" ;
        oef.MODIFY="D" ;
        oef.R_EMP_NO=convertRealToTest(PERNR) ;
        if(!APPU_NUMB.equals("")){
        	oef.A_EMP_NO=convertRealToTest(APPU_NUMB) ;
        }
        oef.SUB_STATUS="�������" ;

        return oef;
    }

    // ������ ���繮�� ���� 09.09.28 �̹� ���ڰ��翡 ��Ҵµ� �׽�ũ�� �ٸ� ����ڰ� ���� �����û�� ���� �����ڻ���
    public ElofficInterfaceData makeDocForDelete(String AINF_SEQN ,String SServer,String PERNR ,String UPMU_NAME ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);

        oef.MAIN_STATUS="M" ;
        oef.MODIFY="D" ;
        oef.R_EMP_NO=convertRealToTest(APPU_NUMB) ;
        oef.A_EMP_NO="" ;
        oef.SUB_STATUS="�����߻���" ;

        Logger.debug.println(this ,"makeDocForDelete====AINF_SEQN:"+AINF_SEQN+"======oef=>>>"+oef.toString());
        return oef;
    }
    // ������ ���繮�� ���� 09.09.28 �̹� ���ڰ��翡 ��Ҵµ� �׽�ũ�� �ٸ� ����ڰ� ���� �����û�� ���� �����ڻ���
    public ElofficInterfaceData makeDocForInsert(String AINF_SEQN ,String SServer,String PERNR , String UPMU_NAME ) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);

        oef.MAIN_STATUS="M" ;
        oef.MODIFY="I" ;
        oef.A_EMP_NO=oef.R_EMP_NO;
        oef.R_EMP_NO=convertRealToTest(PERNR);
        oef.SUB_STATUS="������" ;

        return oef;
    }

//  ORG ���ڰ��繮�� �ϰ�����
    public ElofficInterfaceData makeDocOrg(String AINF_SEQN ,String SServer,String MAIN_STATUS , String MODIFY, String A_EMP_NO, String R_EMP_NO, String UPMU_NAME, String SUB_STATUS ) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);
        oef.MAIN_STATUS=MAIN_STATUS ;
        oef.MODIFY=MODIFY ;
        if(!A_EMP_NO.equals("")){
        	oef.A_EMP_NO=convertRealToTest(A_EMP_NO);  //������
        }
        if(!R_EMP_NO.equals("")){
        	oef.R_EMP_NO=convertRealToTest(R_EMP_NO);  //��û��
        }
        oef.SUB_STATUS=SUB_STATUS ;

        return oef;
    }
    // �ݷ�(������� 1�� �̻�)
    public ElofficInterfaceData makeDocForReject(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String PERNR ,String[] rejects) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = init(AINF_SEQN ,SServer ,UPMU_NAME);
        int requesEmpInx = 0;
        for (int i = 0; i < rejects.length; i++) {
            oef.R_EMP_NO = convertRealToTest(rejects[i]);
            requesEmpInx = i;
        } // end for
        oef.MAIN_STATUS="F" ;
        oef.MODIFY="" ;
        oef.SUB_STATUS="�ݷ�" ;

        if (requesEmpInx>0) {
            oef.A_EMP_NO = convertRealToTest( rejects[requesEmpInx-1] );
        }
        else {
        	oef.A_EMP_NO = convertRealToTest(PERNR);
        }
        Logger.debug.println(this ,"makeDocForReject====AINF_SEQN:"+AINF_SEQN+"======oef=>>>"+oef.toString());
        return oef;
    }

    // ���� ����ڿ��� �ݷ�
    public ElofficInterfaceData makeDocForMangerReject(String AINF_SEQN ,String SServer ,String UPMU_NAME ,Vector<ApprovalLineData> vcTempAppLineData) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);

        oef.P_MAIN_STATUS="M" ;
        oef.MAIN_STATUS="P" ;
        oef.SUB_STATUS="���������ڹݷ�" ;
        oef.R_EMP_NO = oef.A_EMP_NO; //�����ҹ����� ������
        for (int i = 0; i < vcTempAppLineData.size(); i++) {
            ApprovalLineData tempAppLine = (ApprovalLineData) vcTempAppLineData.get(i);
            if ("02".equals(tempAppLine.APPU_TYPE) && NumberUtils.toInt(tempAppLine.APPR_SEQN) > 1) {
            	oef.A_EMP_NO = convertRealToTest(tempAppLine.APPU_NUMB); //�����ɻ��
            } // end if
        } // end for
        Logger.debug.println(this ,"makeDocForMangerReject==���� ����ڿ��� �ݷ�========oef=>>>"+oef.toString());
        return oef;
    }

    //  ���� ���
    public ElofficInterfaceData makeDocForCancel(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);

        ApprovalDocumentStateRFC adsRFC = new ApprovalDocumentStateRFC();
        Vector vcResult = adsRFC.getDocumetState(AINF_SEQN);

        Vector vcCurApproval = (Vector)vcResult.get(2);
        Vector vcPreApproval = (Vector)vcResult.get(3);
        String MAIN_STATUS;
        if (vcPreApproval.size() == 0) {
            // ó�� ���� ��û
            MAIN_STATUS="R";
        } else {
            if (vcCurApproval.size() == 0) {
                // ���� �Ϸ� ����
                MAIN_STATUS="F";
            } else {
                // ���� ������ ����
                MAIN_STATUS="M";
            } // end if
        } // end if
        oef.P_MAIN_STATUS=MAIN_STATUS;
        oef.MAIN_STATUS="P" ;

        String rEmpNo = oef.A_EMP_NO;
        //String aEmpNo = oef.R_EMP_NO ;

        oef.R_EMP_NO=rEmpNo ; //�����ҹ����� �����ɻ��
        oef.A_EMP_NO=convertRealToTest(APPU_NUMB) ; //�����һ��
        oef.SUB_STATUS="���" ;
        Logger.debug.println(this ,"makeDocForCancel==========oef=>>>"+oef.toString());
        return oef;
    }

    public ElofficInterfaceData makeDocContents(String AINF_SEQN ,String SServer ,String UPMU_NAME) throws ConfigurationException ,GeneralException
    {
        ElofficInterfaceData oef = init(AINF_SEQN ,SServer ,UPMU_NAME);

        String curApprover = "";
        String doneApprover = "";
        Vector vcApp = new Vector() ;
        // ���� ����
        String MAIN_STATUS;
        String SUB_STATUS;
        ApprovalDocumentStateRFC adsRFC = new ApprovalDocumentStateRFC();
        Vector vcResult = adsRFC.getDocumetState(AINF_SEQN);
        ApprovalDocumentState ads = (ApprovalDocumentState)vcResult.get(0);

        Logger.debug.println(this ," [[ makeDocContents ]] ads.PERNR=>>>"+ads.UPMU_TYPE);
        if (ads.UPMU_TYPE.equals("17")||ads.UPMU_TYPE.equals("18")){ //17:�ʰ�,18:�ް�
        	oef.DUMMY1 = oef.TEMP;
        }else{
        	oef.DUMMY1 = "";
        }
        oef.TEMP="";
        Vector vcCurApproval = (Vector)vcResult.get(2);
        Vector vcPreApproval = (Vector)vcResult.get(3);
        StringBuffer sbUrl =  new StringBuffer(1024);

        if (vcPreApproval.size() == 0) {
            // ó�� ���� ��û
            MAIN_STATUS="R";
            SUB_STATUS="��û";

        } else {
            if (vcCurApproval.size() == 0) {
                // ���� �Ϸ� ����
                MAIN_STATUS="F";
                SUB_STATUS="�Ϸ�";
            } else {
                // ���� ������ ����
                MAIN_STATUS="M";
                SUB_STATUS="������";
            } // end if
        } // end if

        oef.SUB_STATUS=SUB_STATUS ;
        // ������ ,�� ������ ����Ʈ
        vcApp = (Vector) vcResult.get(1);
        // ������ ����Ǽ� ������
        //oef.R_EMP_NO=convertRealToTest(ads.PERNR) ; // ��û�� ���

        oef.MAIN_STATUS=MAIN_STATUS ;

        for (int i = 0; i < vcApp.size(); i++) {
            AppLineData ald = (AppLineData) vcApp.get(i);
            Logger.debug.println(this ,ald);
            if (ald.APPL_APPR_STAT.equals("")) {
                if (curApprover.equals("")) {
                    Logger.debug.println(this ,"makeDocContents=====1==ald.APPL_APPU_NUMB=>>>"+ald.APPL_APPU_NUMB);
                    curApprover = convertRealToTest(ald.APPL_APPU_NUMB);
                } // end if
            } else {
            	//if (doneApprover.equals(""))
                Logger.debug.println(this ,"makeDocContents=====2==ald.APPL_APPU_NUMB=>>>"+ald.APPL_APPU_NUMB);
            	     doneApprover = convertRealToTest(ald.APPL_APPU_NUMB);
            	//else
                //     doneApprover = doneApprover + ";" + convertRealToTest(ald.APPL_APPU_NUMB);
                Logger.debug.println(this ,"2 doneApprover = "  + ald.APPL_APPU_NUMB);
            } // end if

            //oef.R_EMP_NO=convertRealToTest(ald.APPL_APPU_NUMB);
        } // end for
        oef.A_EMP_NO=curApprover ;
        Logger.debug.println(this ,"a 3 doneApprover = "  +doneApprover);
        if(doneApprover.equals("")){
            Logger.debug.println(this ,"b makeDocContents=====3==ads.PERNR=>>>"+ads.PERNR);
        	oef.R_EMP_NO= convertRealToTest(ads.PERNR) ;   ; // ��û�� ���
            Logger.debug.println(this ,"c3 doneApprover = "  +doneApprover);
        }else
            oef.R_EMP_NO = doneApprover;
        Logger.debug.println(this ,"d 1=doneApprover:"+doneApprover+"===makeDocContents==========oef=>>>return "+oef.toString());
        return oef;
    }

    // ��� ���� (ElOffice ,�׽�Ʈ ��� ����)
    private String convertRealToTest(String empNo) throws ConfigurationException
    {
        Config conf  = new Configuration();
        String convertEmpNo;

        Logger.debug.println(this ,"convertRealToTest=====3==empNo=>>>"+empNo);
        if (conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP")) {
            convertEmpNo = conf.getString("com.sns.jdf.eloffice." + DataUtil.fixZero(empNo, 8));
            if (convertEmpNo == null || convertEmpNo.equals("")) {
                throw new ConfigurationException("��� ���� ����");
            } // end if
        } else {

            convertEmpNo = DataUtil.fixZero(empNo, 8);
            //if (empNo.substring(0 ,3).equals("002")) {
            //    convertEmpNo = empNo;
            //} else {
            //    convertEmpNo = empNo.substring(3 ,8);
            //} // end if

        } // end if

        return convertEmpNo;
    }

}
