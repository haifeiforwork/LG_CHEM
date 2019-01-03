/*
 * 작성된 날짜: 2005. 2. 2.
 *
 */
package hris.common;

import hris.G.ApprovalDocumentState;
import hris.G.rfc.ApprovalDocumentStateRFC;

import java.util.Vector;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.ConfigurationException;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.util.DataUtil;

/**
 * @author 이승희
 *
 */
public class DraftDocForEloffice_Global
{
    String parameters[] = { "Subject" ,"DocID" , "LinkURL" ,"HDocStatus" , "WriterSabun" 
            ,"HCurApproverSabun" , "HDoneApproverSabun" ,"HrealApproverListSabun" ,"HRefListSabun" };
    
    
    
    private ElofficInterfaceData_Global init(String AINF_SEQN ,String SServer ,String UPMU_NAME) throws ConfigurationException
    {
        Config conf  = new Configuration();
        ElofficInterfaceData_Global oef = new ElofficInterfaceData_Global();
        
        oef.SServer = SServer;
        oef.Subject = UPMU_NAME;
        oef.DocID = AINF_SEQN;
        oef.LinkURL = conf.getString("com.sns.jdf.eloffice.ResponseURL");   //ehr.lgchem.com
        
        return oef;
    }
    
    // 결재 문서 삭제
    public ElofficInterfaceData_Global makeDocForRemove(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String PERNR ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = init(AINF_SEQN ,SServer ,UPMU_NAME);
        oef.HDocStatus = "1300006";
        oef.WriterSabun = convertRealToTest(PERNR);
        oef.HCurApproverSabun = convertRealToTest(APPU_NUMB);
        return oef;
    }
    
    // 결재자 변경
    public ElofficInterfaceData_Global makeDocForChange(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);
        oef.HDocStatus = "1300005";
        oef.HMApproverSabun= convertRealToTest(APPU_NUMB);
        return oef;
    }

    // 반려(결재권자 1인 이상)
    public ElofficInterfaceData_Global makeDocForReject(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String PERNR ,String[] rejects) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = init(AINF_SEQN ,SServer ,UPMU_NAME);
        
        oef.HDoneApproverSabun = convertRealToTest(PERNR);
        for (int i = 0; i < rejects.length; i++) {
            oef.HDoneApproverSabun = oef.HDoneApproverSabun + ";" + convertRealToTest(rejects[i]);
        } // end for
        oef.HDocStatus = "1300004";
        return oef;
    }
    
    // 업무 담당자에게 반려
    public ElofficInterfaceData_Global makeDocForMangerReject(String AINF_SEQN ,String SServer ,String UPMU_NAME ,Vector vcTempAppLineData) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);
        oef.HDocStatus = "1300010";
        oef.HinvApproverList = "";
        for (int i = 0; i < vcTempAppLineData.size(); i++) {
            AppLineData tempAppLine = (AppLineData) vcTempAppLineData.get(i);
            if (tempAppLine.APPL_APPU_TYPE.equals("02") && Integer.parseInt(tempAppLine.APPL_APPR_SEQN) > 1) {
                oef.HinvApproverList = oef.HinvApproverList + ";" + convertRealToTest(tempAppLine.APPL_APPU_NUMB);
            } // end if
        } // end for
        
        return oef;
    }
    
    //  결재 취소 = 裁决取消
    public ElofficInterfaceData_Global makeDocForCancel(String AINF_SEQN ,String SServer ,String UPMU_NAME ,String APPU_NUMB) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = makeDocContents(AINF_SEQN ,SServer ,UPMU_NAME);
        oef.HDocStatus = "1300007";
        oef.HMApproverSabun = convertRealToTest(APPU_NUMB);
        return oef;
    }
    
    
    public ElofficInterfaceData_Global makeDocContents(String AINF_SEQN ,String SServer ,String UPMU_NAME) throws ConfigurationException ,GeneralException
    {
    	ElofficInterfaceData_Global oef = init(AINF_SEQN ,SServer ,UPMU_NAME);
        
        String curApprover = "";
        String doneApprover = "";
        
      
        ApprovalDocumentStateRFC adsRFC = new ApprovalDocumentStateRFC();
        Vector vcResult = adsRFC.getDocumetState(AINF_SEQN);
        
        ApprovalDocumentState ads = (ApprovalDocumentState)vcResult.get(0);  //ApprovalDocumentState
        Logger.debug.println(this ,ads);
        
        Vector vcCurApproval = (Vector)vcResult.get(2);   //Current Decisioner List
        Vector vcPreApproval = (Vector)vcResult.get(3);   //Previous Decisioner List
        
//        StringBuffer sbUrl =  new StringBuffer(1024);
        
        // 결제 상태 = 结算状态
        long type;
        if (vcPreApproval.size() == 0) {
            // 처음 결재 신청 = 第一次裁决申请
            type = 1300002;
        } else {
            if (vcCurApproval.size() == 0) {
                // 결재 완료 문서
                type = 1300009;
            } else {
                // 결재 진행중 문서
                type = 1300003;
            } // end if
        } // end if
        oef.HDocStatus = DataUtil.fixEndZero(String.valueOf(type) , 6);
        
        // 신청자 사번 = 申请者employeeNumber
        oef.WriterSabun = convertRealToTest(ads.PERNR);
        Logger.debug.println(this ," writer = "  + ads.PERNR);
        
        // 결재자 ,기 결재자 리스트  = 裁决者, 裁决者名单
        Vector vcApp = (Vector) vcResult.get(1);   //Decision Information
        doneApprover = convertRealToTest(ads.PERNR);
        for (int i = 0; i < vcApp.size(); i++) {
            AppLineData ald = (AppLineData) vcApp.get(i);
            Logger.debug.println(this ,ald);
            if (ald.APPL_APPR_STAT.equals("")) {
                if (curApprover.equals("")) {
                    Logger.debug.println(this ," curApprover = "  + ald.APPL_APPU_NUMB);
                    curApprover = convertRealToTest(ald.APPL_APPU_NUMB);
                } // end if
            } else {
                doneApprover = doneApprover + ";" + convertRealToTest(ald.APPL_APPU_NUMB);
                Logger.debug.println(this ," doneApprover = "  + ald.APPL_APPU_NUMB);
            } // end if
        } // end for
        
        oef.HCurApproverSabun = curApprover;
        oef.HDoneApproverSabun = doneApprover;
        
        return oef;
    }
    
    
    // 사번 변경 (ElOffice ,테스트 사번 연계)
    private String convertRealToTest(String empNo) throws ConfigurationException
    {
        Config conf  = new Configuration();
        String convertEmpNo;

        if (conf.getBoolean("com.sns.jdf.eloffice.ISDEVELOP")) {
            convertEmpNo = conf.getString("com.sns.jdf.eloffice." + DataUtil.fixZero(empNo, 8));
            if (convertEmpNo == null || convertEmpNo.equals("")) {
                throw new ConfigurationException("사번 맵핑 에러");
            } // end if
        } else {
            if (empNo.substring(0 ,3).equals("002")) {
                convertEmpNo = empNo;
            } else {
                convertEmpNo = empNo.substring(3 ,8);
            } // end if
            
        } // end if
        
        return convertEmpNo;
    }
    
}
