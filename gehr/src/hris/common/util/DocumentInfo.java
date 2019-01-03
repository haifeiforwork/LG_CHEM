/*
 * 작성된 날짜: 2005. 2. 25.
 *
 */
package hris.common.util;

import hris.G.ApprovalDocumentState;
import hris.G.DocInfoEntityData;
import hris.G.rfc.ApprovalDocumentStateRFC;

import java.util.Vector;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;

/**
 * @author 이승희
 *
 */
public class DocumentInfo
{
    private String AINF_SEQN;    // 문서 번호
    private String UPMU_TYPE;    // 업무 형태
    
    private String proxyPernr;   // 대리 신청자 사번 
    private String prenr;        // 피 신청자 사번
    
    private boolean isUnderApproval;      // 결재 진행중에서 문서 접근 여부. 
    
    private boolean modefy;               // 문서의 수정과 삭제 가능 여부
    
    private String empNo;                  // 현 사용자
    
    private String APPU_TYPE;              // 결재 타입
    private String APPR_SEQN;              // 결재 순번
    
    private boolean isHaveAuth = false;  // 문서 접근 권한 
    private boolean isHasApproval;
    private boolean hasCancel;
    
    // 결재자 구분
    private int approvalStep;                            // 결재자 구분 값
    public final static int POST_MANGER         = 1;    // 부서장
    public final static int DUTY_CHARGER        = 5;    // 업무 담당자 
    public final static int DUTY_MANGER         = 6;    // 업무 담당 부서장
    public final static int INFORMAL_SECRETARY  = 11;   // 인포멀 간사
    
    // 문서와 관계
    private int  relation;
    public final static int NONE                = 0;    // 관련 없음
    public final static int REQUSTER            = 1;    // 신청자
    public final static int PROXY_REQUSTER      = 2;    // 대리 신청자
    public final static int APPROVAL            = 3;    // 현재 결재자
    public final static int PRE_APPROVAL        = 4;    // 이전 결재자
    public final static int HAVE_DUTY_TASK      = 5;    // 조회 가능 업무 담당자
    
    // 문서 분기 
    private int type;                                     // 문서 분기 구분
    public final static int FINISH_APPROVAL     = 1;     // 결재 완료 문서 
    public final static int MUST_APPROVAL       = 2;     // 결재 해야할 문서
    
    public final static int EDIT_ENABLE         = 3;     // 결재 진행중 문서 ,내용 수정 가능 문서
    public final static int EDIT_DISABLE        = 4;     // 결재 진행중 문서 ,내용 수정 불가 문서
    
    public final static int CANCEL_ENABLE       = 5;     // 결재 진행중 문서 ,승인 취소 가능 문서
    public final static int CANCEL_DISABLE      = 6;     // 결재 진행중 문서 ,승인 취소 불가 문서
    
    // 문서 상태
    private int docStat;
    public final static int BEFORE_APPROVAL = 1;
    public final static int UNDER_APPROVAL = 2;
    public final static int END_APPROVAL = 9;
    
    
    private Vector vcResult;
    private ApprovalDocumentState ads;
    private DocInfoEntityData curApprovals[];
    private DocInfoEntityData preApprovals[];
    private DocInfoEntityData haveTasks[];
    
    /**
     * @param ainf_seqn
     * @param empNo
     */
    public DocumentInfo(String ainf_seqn, String empNo) throws GeneralException
    {
        this(ainf_seqn, empNo , true);
    }
    
    public DocumentInfo(String ainf_seqn, String empNo ,boolean isEdit) throws GeneralException
    {
        AINF_SEQN = ainf_seqn;
        this.empNo = empNo;
        this.isUnderApproval = isEdit;
        process();
    }
    
    /**
     * 
     * @throws GeneralException
     */
    private void preProcess() throws GeneralException
    {
        Vector vcCurApproval;
        Vector vcPreApproval;
        Vector vcHaveTask;
        
        ApprovalDocumentStateRFC adsRFC = new ApprovalDocumentStateRFC();
        
        vcResult = adsRFC.getDocumetState(AINF_SEQN);
        
        ads = (ApprovalDocumentState)vcResult.get(0);
        Logger.debug.println(this ,ads);
        
        // 현재 결재자
        vcCurApproval = (Vector)vcResult.get(2);
        Logger.debug.println(this ,vcCurApproval);
        if (vcCurApproval.size() > 0) {
            curApprovals = new DocInfoEntityData[vcCurApproval.size()];
            for (int i = 0; i < vcCurApproval.size(); i++) {
                curApprovals[i]  =  (DocInfoEntityData)vcCurApproval.get(i);
            } // end for
        } // end if
        
        // 이전  결재자
        vcPreApproval = (Vector)vcResult.get(3);
        Logger.debug.println(this ,vcPreApproval);
        if (vcPreApproval.size() > 0) {
            preApprovals = new DocInfoEntityData[vcPreApproval.size()];
            for (int i = 0; i < vcPreApproval.size(); i++) {
                preApprovals[i]  =   (DocInfoEntityData) vcPreApproval.get(i);
            } // end for
        } // end if
        
        // 문서 상태 설정
        if (curApprovals == null || curApprovals.length < 1) {
            docStat = DocumentInfo.END_APPROVAL;
        } else if (preApprovals == null || preApprovals.length < 1) {
            docStat = DocumentInfo.BEFORE_APPROVAL;
        } else {
            docStat = DocumentInfo.UNDER_APPROVAL;
        } // end if
        
        // 업무 담당자 
        vcHaveTask = (Vector)vcResult.get(4);
        Logger.debug.println(this ,vcHaveTask);
        if (vcHaveTask.size() > 0) {
            haveTasks = new DocInfoEntityData[vcHaveTask.size()];
            for (int i = 0; i < vcHaveTask.size(); i++) {
                haveTasks[i]  =   (DocInfoEntityData) vcHaveTask.get(i);
            } // end for
        } // end if
        return;
    }
    
    /**
     *  문서와 사원(empNo) 과의 관계 
     * relation 값 설정
     */
    private void relateionProcess() throws GeneralException
    {
        int temp1stRelation = DocumentInfo.NONE;            // 임시 관계 설정 변수 
        int temp2ndRelation = DocumentInfo.NONE;            // 임시 관계 설정 변수
        int temp3thRelation = DocumentInfo.NONE;            // 임시 관계 설정 변수
        
        setRelation(DocumentInfo.NONE);
        
        if (ads.PERNR.equals(empNo)) {
            // 신청자
            setRelation(DocumentInfo.REQUSTER);
            temp1stRelation = DocumentInfo.REQUSTER;
        } else if (ads.ZPERNR.equals(empNo)) {
            // 대리 신청자
            setRelation(DocumentInfo.PROXY_REQUSTER);
            // 대리 신청자와 신청자 동일시 함.
            temp1stRelation = DocumentInfo.REQUSTER;
        } // end if
        
        if (curApprovals != null && curApprovals.length > 0) {      // 현재 결재자
            
            for (int i = 0; i < curApprovals.length; i++) {
                Logger.debug.println("curApprovals : " + curApprovals[i]);
                if (curApprovals[i].PERNR.equals(empNo)) {
                    setAPPU_TYPE(curApprovals[i].APPU_TYPE);
                    setAPPR_SEQN(curApprovals[i].APPR_SEQN);
                    temp2ndRelation = DocumentInfo.APPROVAL;
                    break;
                } // end if
            } // end for
        } // end if
        
        if (temp2ndRelation == DocumentInfo.NONE && preApprovals != null && preApprovals.length > 0) {     // 이전 결재자
            String tempAPPU_TYPE = null;
            String tempAPPR_SEQN = null;
            for (int i = preApprovals.length - 1; i >= 0; i--) {
                Logger.debug.println("preApprovals : " + preApprovals[i]);
                
                if (i == (preApprovals.length - 1)) {
                    tempAPPU_TYPE = preApprovals[i].APPU_TYPE;
                    tempAPPR_SEQN = preApprovals[i].APPR_SEQN;
                    // 결재 취소 권한 
                    hasCancel = true;                                 
                } else if (!tempAPPU_TYPE.equals(preApprovals[i].APPU_TYPE) || !tempAPPR_SEQN.equals(preApprovals[i].APPR_SEQN)) {
                    // 결재 취소 권한
                    hasCancel = false;                                 
                } // end if
                
                if (preApprovals[i].PERNR.equals(empNo)) {
                    setAPPU_TYPE(preApprovals[i].APPU_TYPE);
                    setAPPR_SEQN(preApprovals[i].APPR_SEQN);
                    temp2ndRelation = DocumentInfo.PRE_APPROVAL;
                    break;
                } // end if
            } // end for
        } // end if
        
        if (haveTasks != null && haveTasks.length > 0) {   // 업무 담당자
            for (int i = 0; i < haveTasks.length; i++) {
                Logger.debug.println("haveTasks : " + haveTasks[i]);
                
                if (haveTasks[i].PERNR.equals(empNo)) {
                    temp3thRelation = DocumentInfo.HAVE_DUTY_TASK;
                    break;
                } // end if
            } // end for
        } // end if
        
        /*
         * 기본 초기 조건 
         * temp1stRelation != DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE
         *  또는 
         * temp1stRelation == DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE
         */
        if (temp1stRelation == DocumentInfo.NONE && temp2ndRelation != DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE) { // 결재자   
            setRelation(temp2ndRelation);
        } else if (temp1stRelation == DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation != DocumentInfo.NONE) {   
            setRelation(DocumentInfo.HAVE_DUTY_TASK); 
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp2ndRelation == DocumentInfo.APPROVAL) {       // 신청자 & 현재 결재자
            if (!isUnderApproval) {      // 편집 가능 화면에서 요구(결재 진행중 or 상세/ 삭제) 
                setRelation(DocumentInfo.APPROVAL);
            } // end if
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp2ndRelation == DocumentInfo.PRE_APPROVAL) {    // 신청자 & 이전 결재자
            setRelation(DocumentInfo.PRE_APPROVAL);
            
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {  // 신청자 & 업무 담당자
            
            
        } else if (temp2ndRelation == DocumentInfo.APPROVAL && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {  // 결재자 & 업무 담당자
            if (isUnderApproval) {      // 편집 가능 화면에서 요구(결재 진행중 or 상세/ 삭제)
                setRelation(DocumentInfo.HAVE_DUTY_TASK);
            } else {
                setRelation(DocumentInfo.APPROVAL);
            } // end if
        } else if (temp2ndRelation == DocumentInfo.PRE_APPROVAL && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {    // 이전 결재자 & 업무 담당자
            setRelation(DocumentInfo.PRE_APPROVAL);
        } // end if
        return;
    }
    
    private void process() throws GeneralException
    {
        
        preProcess();
        
        setUPMU_TYPE(ads.UPMU_TYPE);        // 업무 구분
        setPrenr(ads.PERNR);                // 신청자
        setProxyPernr(ads.ZPERNR);          // 대리 신청자
        
        // 문서와 관계
        relateionProcess();
        Logger.debug.println(this ,"relation = " + getRelation());

        // 접근 가능 여부
        if (getRelation() == DocumentInfo.NONE) {
            setType(0);
            setHaveAuth(false);
            return;
        } else {
            setHaveAuth(true);
        } // end if
        
        // 문서 내용 수정 여부
        if (docStat == DocumentInfo.BEFORE_APPROVAL && (relation == DocumentInfo.REQUSTER || relation == DocumentInfo.PROXY_REQUSTER)) {
            setModefy(true);
        } // end if
        
        // 결재자 단계 구분
        // 1 : 부서장 , 5 : 담당자 , 6 : 담당부서장 
        if (getRelation() == DocumentInfo.APPROVAL || getRelation() == DocumentInfo.PRE_APPROVAL) {
            int APPU_TYPE = 0;
            int APPR_SEQN = 0;
            APPU_TYPE = Integer.parseInt(getAPPU_TYPE());
            APPR_SEQN = Integer.parseInt(getAPPR_SEQN());
            switch (APPU_TYPE) {
                case 0:
                    switch (APPR_SEQN) {
                        case 0:
                            // 인포멀 간사
                            approvalStep  = DocumentInfo.INFORMAL_SECRETARY;
                            break;
                    } // end switch
                    break;
                case 1:
                    switch (APPR_SEQN) {
                        case 1:
                            // 신청 부서장
                            approvalStep  = DocumentInfo.POST_MANGER;
                            break;
                    } // end switch
                    break;
                case 2:
                    switch (APPR_SEQN) {
                        case 1:
                            // 업무 담당자
                            approvalStep  = DocumentInfo.DUTY_CHARGER;
                            break;
                        case 2:
                            // 업무 담당 부서장
                            approvalStep  = DocumentInfo.DUTY_MANGER;
                            break;
                    } // end switch
                    break;
                default:
                    Logger.info.println(this ,"[" + getAPPU_TYPE() + "][" + getAPPR_SEQN() + "]" +  empNo + ": 사번에 대한 결재 단계가 없음");
                    break;
            } // end switch
        } else {
            Logger.info.println(this ,  empNo + ": 은 결재자 권한이 없습니다.");
        } // end if
        
        if (docStat == DocumentInfo.END_APPROVAL) {
            // 결재 완료 문서 
            type = DocumentInfo.FINISH_APPROVAL;
        } else if (getRelation() == DocumentInfo.APPROVAL) {
            // 결재 해야할 문서
            type = DocumentInfo.MUST_APPROVAL;
        } else if (getRelation() == DocumentInfo.HAVE_DUTY_TASK) {
            // 담당 업무 타스크 (수정 불가 신청)
            type = DocumentInfo.EDIT_DISABLE;
        } else {
            // 결재 진행중 문서
            if (isModefy()) {
                // 내용 수정 가능 문서
                type = DocumentInfo.EDIT_ENABLE;
            } else if ((getRelation() == DocumentInfo.REQUSTER || getRelation() == DocumentInfo.PROXY_REQUSTER) && docStat != DocumentInfo.BEFORE_APPROVAL) {
                // 내용 수정 불가 문서
                type = DocumentInfo.EDIT_DISABLE;
            } else if (getRelation() == DocumentInfo.PRE_APPROVAL && hasCancel) {
                // 승인 취소 가능 문서
                type = DocumentInfo.CANCEL_ENABLE;
            } else {
                // 승인 취소 불가 문서
                type = DocumentInfo.CANCEL_DISABLE;
            } // end if
        } // end if
    }
    /**
     * @return isHaveAuth을 리턴합니다.
     */
    public boolean isHaveAuth()
    {
        return isHaveAuth;
    }
    /**
     * @param isHaveAuth 설정하려는 isHaveAuth.
     */
    public void setHaveAuth(boolean isHaveAuth)
    {
        this.isHaveAuth = isHaveAuth;
    }
    /**
     * @return prenr을 리턴합니다.
     */
    public String getPrenr()
    {
        return prenr;
    }
    /**
     * @param prenr 설정하려는 prenr.
     */
    public void setPrenr(String prenr)
    {
        this.prenr = prenr;
    }
    /**
     * @return proxyPernr을 리턴합니다.
     */
    public String getProxyPernr()
    {
        return proxyPernr;
    }
    /**
     * @param proxyPernr 설정하려는 proxyPernr.
     */
    public void setProxyPernr(String proxyPernr)
    {
        this.proxyPernr = proxyPernr;
    }
    /**
     * @return type을 리턴합니다.
     */
    public int getType()
    {
        return type;
    }
    /**
     * @param type 설정하려는 type.
     */
    public void setType(int type)
    {
        this.type = type;
    }
    /**
     * @return approvalStep을 리턴합니다.
     */
    public int getApprovalStep()
    {
        return approvalStep;
    }
    /**
     * @param approvalStep 설정하려는 approvalStep.
     */
    public void setApprovalStep(int approvalStep)
    {
        this.approvalStep = approvalStep;
    }
    /**
     * @return uPMU_TYPE을 리턴합니다.
     */
    public String getUPMU_TYPE()
    {
        return UPMU_TYPE;
    }
    /**
     * @param upmu_type 설정하려는 uPMU_TYPE.
     */
    public void setUPMU_TYPE(String upmu_type)
    {
        UPMU_TYPE = upmu_type;
    }
    /**
     * @return modefy을 리턴합니다.
     */
    public boolean isModefy()
    {
        return modefy;
    }
    /**
     * @param modefy 설정하려는 modefy.
     */
    public void setModefy(boolean modefy)
    {
        this.modefy = modefy;
    }
    /**
     * @return relation을 리턴합니다.
     */
    public int getRelation()
    {
        return relation;
    }
    /**
     * @param relation 설정하려는 relation.
     */
    public void setRelation(int relation)
    {
        this.relation = relation;
    }
    /**
     * @return aPPR_SEQN을 리턴합니다.
     */
    public String getAPPR_SEQN()
    {
        return APPR_SEQN;
    }
    /**
     * @param appr_seqn 설정하려는 aPPR_SEQN.
     */
    public void setAPPR_SEQN(String appr_seqn)
    {
        APPR_SEQN = appr_seqn;
    }
    /**
     * @return aPPU_TYPE을 리턴합니다.
     */
    public String getAPPU_TYPE()
    {
        return APPU_TYPE;
    }
    /**
     * @param appu_type 설정하려는 aPPU_TYPE.
     */
    public void setAPPU_TYPE(String appu_type)
    {
        APPU_TYPE = appu_type;
    }
    
    /**
     * @return hasCancel을 리턴합니다.
     */
    public boolean isHasCancel()
    {
        return hasCancel;
    }
    /**
     * @param hasCancel 설정하려는 hasCancel.
     */
    public void setHasCancel(boolean hasCancel)
    {
        this.hasCancel = hasCancel;
    }
    /**
     * @return docStat을 리턴합니다.
     */
    public int getDocStat()
    {
        return docStat;
    }
    /**
     * @param docStat 설정하려는 docStat.
     */
    public void setDocStat(int docStat)
    {
        this.docStat = docStat;
    }
}
