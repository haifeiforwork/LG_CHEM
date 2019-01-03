/*
 * �ۼ��� ��¥: 2005. 2. 25.
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
 * @author �̽���
 *
 */
public class DocumentInfo
{
    private String AINF_SEQN;    // ���� ��ȣ
    private String UPMU_TYPE;    // ���� ����
    
    private String proxyPernr;   // �븮 ��û�� ��� 
    private String prenr;        // �� ��û�� ���
    
    private boolean isUnderApproval;      // ���� �����߿��� ���� ���� ����. 
    
    private boolean modefy;               // ������ ������ ���� ���� ����
    
    private String empNo;                  // �� �����
    
    private String APPU_TYPE;              // ���� Ÿ��
    private String APPR_SEQN;              // ���� ����
    
    private boolean isHaveAuth = false;  // ���� ���� ���� 
    private boolean isHasApproval;
    private boolean hasCancel;
    
    // ������ ����
    private int approvalStep;                            // ������ ���� ��
    public final static int POST_MANGER         = 1;    // �μ���
    public final static int DUTY_CHARGER        = 5;    // ���� ����� 
    public final static int DUTY_MANGER         = 6;    // ���� ��� �μ���
    public final static int INFORMAL_SECRETARY  = 11;   // ������ ����
    
    // ������ ����
    private int  relation;
    public final static int NONE                = 0;    // ���� ����
    public final static int REQUSTER            = 1;    // ��û��
    public final static int PROXY_REQUSTER      = 2;    // �븮 ��û��
    public final static int APPROVAL            = 3;    // ���� ������
    public final static int PRE_APPROVAL        = 4;    // ���� ������
    public final static int HAVE_DUTY_TASK      = 5;    // ��ȸ ���� ���� �����
    
    // ���� �б� 
    private int type;                                     // ���� �б� ����
    public final static int FINISH_APPROVAL     = 1;     // ���� �Ϸ� ���� 
    public final static int MUST_APPROVAL       = 2;     // ���� �ؾ��� ����
    
    public final static int EDIT_ENABLE         = 3;     // ���� ������ ���� ,���� ���� ���� ����
    public final static int EDIT_DISABLE        = 4;     // ���� ������ ���� ,���� ���� �Ұ� ����
    
    public final static int CANCEL_ENABLE       = 5;     // ���� ������ ���� ,���� ��� ���� ����
    public final static int CANCEL_DISABLE      = 6;     // ���� ������ ���� ,���� ��� �Ұ� ����
    
    // ���� ����
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
        
        // ���� ������
        vcCurApproval = (Vector)vcResult.get(2);
        Logger.debug.println(this ,vcCurApproval);
        if (vcCurApproval.size() > 0) {
            curApprovals = new DocInfoEntityData[vcCurApproval.size()];
            for (int i = 0; i < vcCurApproval.size(); i++) {
                curApprovals[i]  =  (DocInfoEntityData)vcCurApproval.get(i);
            } // end for
        } // end if
        
        // ����  ������
        vcPreApproval = (Vector)vcResult.get(3);
        Logger.debug.println(this ,vcPreApproval);
        if (vcPreApproval.size() > 0) {
            preApprovals = new DocInfoEntityData[vcPreApproval.size()];
            for (int i = 0; i < vcPreApproval.size(); i++) {
                preApprovals[i]  =   (DocInfoEntityData) vcPreApproval.get(i);
            } // end for
        } // end if
        
        // ���� ���� ����
        if (curApprovals == null || curApprovals.length < 1) {
            docStat = DocumentInfo.END_APPROVAL;
        } else if (preApprovals == null || preApprovals.length < 1) {
            docStat = DocumentInfo.BEFORE_APPROVAL;
        } else {
            docStat = DocumentInfo.UNDER_APPROVAL;
        } // end if
        
        // ���� ����� 
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
     *  ������ ���(empNo) ���� ���� 
     * relation �� ����
     */
    private void relateionProcess() throws GeneralException
    {
        int temp1stRelation = DocumentInfo.NONE;            // �ӽ� ���� ���� ���� 
        int temp2ndRelation = DocumentInfo.NONE;            // �ӽ� ���� ���� ����
        int temp3thRelation = DocumentInfo.NONE;            // �ӽ� ���� ���� ����
        
        setRelation(DocumentInfo.NONE);
        
        if (ads.PERNR.equals(empNo)) {
            // ��û��
            setRelation(DocumentInfo.REQUSTER);
            temp1stRelation = DocumentInfo.REQUSTER;
        } else if (ads.ZPERNR.equals(empNo)) {
            // �븮 ��û��
            setRelation(DocumentInfo.PROXY_REQUSTER);
            // �븮 ��û�ڿ� ��û�� ���Ͻ� ��.
            temp1stRelation = DocumentInfo.REQUSTER;
        } // end if
        
        if (curApprovals != null && curApprovals.length > 0) {      // ���� ������
            
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
        
        if (temp2ndRelation == DocumentInfo.NONE && preApprovals != null && preApprovals.length > 0) {     // ���� ������
            String tempAPPU_TYPE = null;
            String tempAPPR_SEQN = null;
            for (int i = preApprovals.length - 1; i >= 0; i--) {
                Logger.debug.println("preApprovals : " + preApprovals[i]);
                
                if (i == (preApprovals.length - 1)) {
                    tempAPPU_TYPE = preApprovals[i].APPU_TYPE;
                    tempAPPR_SEQN = preApprovals[i].APPR_SEQN;
                    // ���� ��� ���� 
                    hasCancel = true;                                 
                } else if (!tempAPPU_TYPE.equals(preApprovals[i].APPU_TYPE) || !tempAPPR_SEQN.equals(preApprovals[i].APPR_SEQN)) {
                    // ���� ��� ����
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
        
        if (haveTasks != null && haveTasks.length > 0) {   // ���� �����
            for (int i = 0; i < haveTasks.length; i++) {
                Logger.debug.println("haveTasks : " + haveTasks[i]);
                
                if (haveTasks[i].PERNR.equals(empNo)) {
                    temp3thRelation = DocumentInfo.HAVE_DUTY_TASK;
                    break;
                } // end if
            } // end for
        } // end if
        
        /*
         * �⺻ �ʱ� ���� 
         * temp1stRelation != DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE
         *  �Ǵ� 
         * temp1stRelation == DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE
         */
        if (temp1stRelation == DocumentInfo.NONE && temp2ndRelation != DocumentInfo.NONE && temp3thRelation == DocumentInfo.NONE) { // ������   
            setRelation(temp2ndRelation);
        } else if (temp1stRelation == DocumentInfo.NONE && temp2ndRelation == DocumentInfo.NONE && temp3thRelation != DocumentInfo.NONE) {   
            setRelation(DocumentInfo.HAVE_DUTY_TASK); 
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp2ndRelation == DocumentInfo.APPROVAL) {       // ��û�� & ���� ������
            if (!isUnderApproval) {      // ���� ���� ȭ�鿡�� �䱸(���� ������ or ��/ ����) 
                setRelation(DocumentInfo.APPROVAL);
            } // end if
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp2ndRelation == DocumentInfo.PRE_APPROVAL) {    // ��û�� & ���� ������
            setRelation(DocumentInfo.PRE_APPROVAL);
            
        } else if (temp1stRelation == DocumentInfo.REQUSTER && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {  // ��û�� & ���� �����
            
            
        } else if (temp2ndRelation == DocumentInfo.APPROVAL && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {  // ������ & ���� �����
            if (isUnderApproval) {      // ���� ���� ȭ�鿡�� �䱸(���� ������ or ��/ ����)
                setRelation(DocumentInfo.HAVE_DUTY_TASK);
            } else {
                setRelation(DocumentInfo.APPROVAL);
            } // end if
        } else if (temp2ndRelation == DocumentInfo.PRE_APPROVAL && temp3thRelation == DocumentInfo.HAVE_DUTY_TASK) {    // ���� ������ & ���� �����
            setRelation(DocumentInfo.PRE_APPROVAL);
        } // end if
        return;
    }
    
    private void process() throws GeneralException
    {
        
        preProcess();
        
        setUPMU_TYPE(ads.UPMU_TYPE);        // ���� ����
        setPrenr(ads.PERNR);                // ��û��
        setProxyPernr(ads.ZPERNR);          // �븮 ��û��
        
        // ������ ����
        relateionProcess();
        Logger.debug.println(this ,"relation = " + getRelation());

        // ���� ���� ����
        if (getRelation() == DocumentInfo.NONE) {
            setType(0);
            setHaveAuth(false);
            return;
        } else {
            setHaveAuth(true);
        } // end if
        
        // ���� ���� ���� ����
        if (docStat == DocumentInfo.BEFORE_APPROVAL && (relation == DocumentInfo.REQUSTER || relation == DocumentInfo.PROXY_REQUSTER)) {
            setModefy(true);
        } // end if
        
        // ������ �ܰ� ����
        // 1 : �μ��� , 5 : ����� , 6 : ���μ��� 
        if (getRelation() == DocumentInfo.APPROVAL || getRelation() == DocumentInfo.PRE_APPROVAL) {
            int APPU_TYPE = 0;
            int APPR_SEQN = 0;
            APPU_TYPE = Integer.parseInt(getAPPU_TYPE());
            APPR_SEQN = Integer.parseInt(getAPPR_SEQN());
            switch (APPU_TYPE) {
                case 0:
                    switch (APPR_SEQN) {
                        case 0:
                            // ������ ����
                            approvalStep  = DocumentInfo.INFORMAL_SECRETARY;
                            break;
                    } // end switch
                    break;
                case 1:
                    switch (APPR_SEQN) {
                        case 1:
                            // ��û �μ���
                            approvalStep  = DocumentInfo.POST_MANGER;
                            break;
                    } // end switch
                    break;
                case 2:
                    switch (APPR_SEQN) {
                        case 1:
                            // ���� �����
                            approvalStep  = DocumentInfo.DUTY_CHARGER;
                            break;
                        case 2:
                            // ���� ��� �μ���
                            approvalStep  = DocumentInfo.DUTY_MANGER;
                            break;
                    } // end switch
                    break;
                default:
                    Logger.info.println(this ,"[" + getAPPU_TYPE() + "][" + getAPPR_SEQN() + "]" +  empNo + ": ����� ���� ���� �ܰ谡 ����");
                    break;
            } // end switch
        } else {
            Logger.info.println(this ,  empNo + ": �� ������ ������ �����ϴ�.");
        } // end if
        
        if (docStat == DocumentInfo.END_APPROVAL) {
            // ���� �Ϸ� ���� 
            type = DocumentInfo.FINISH_APPROVAL;
        } else if (getRelation() == DocumentInfo.APPROVAL) {
            // ���� �ؾ��� ����
            type = DocumentInfo.MUST_APPROVAL;
        } else if (getRelation() == DocumentInfo.HAVE_DUTY_TASK) {
            // ��� ���� Ÿ��ũ (���� �Ұ� ��û)
            type = DocumentInfo.EDIT_DISABLE;
        } else {
            // ���� ������ ����
            if (isModefy()) {
                // ���� ���� ���� ����
                type = DocumentInfo.EDIT_ENABLE;
            } else if ((getRelation() == DocumentInfo.REQUSTER || getRelation() == DocumentInfo.PROXY_REQUSTER) && docStat != DocumentInfo.BEFORE_APPROVAL) {
                // ���� ���� �Ұ� ����
                type = DocumentInfo.EDIT_DISABLE;
            } else if (getRelation() == DocumentInfo.PRE_APPROVAL && hasCancel) {
                // ���� ��� ���� ����
                type = DocumentInfo.CANCEL_ENABLE;
            } else {
                // ���� ��� �Ұ� ����
                type = DocumentInfo.CANCEL_DISABLE;
            } // end if
        } // end if
    }
    /**
     * @return isHaveAuth�� �����մϴ�.
     */
    public boolean isHaveAuth()
    {
        return isHaveAuth;
    }
    /**
     * @param isHaveAuth �����Ϸ��� isHaveAuth.
     */
    public void setHaveAuth(boolean isHaveAuth)
    {
        this.isHaveAuth = isHaveAuth;
    }
    /**
     * @return prenr�� �����մϴ�.
     */
    public String getPrenr()
    {
        return prenr;
    }
    /**
     * @param prenr �����Ϸ��� prenr.
     */
    public void setPrenr(String prenr)
    {
        this.prenr = prenr;
    }
    /**
     * @return proxyPernr�� �����մϴ�.
     */
    public String getProxyPernr()
    {
        return proxyPernr;
    }
    /**
     * @param proxyPernr �����Ϸ��� proxyPernr.
     */
    public void setProxyPernr(String proxyPernr)
    {
        this.proxyPernr = proxyPernr;
    }
    /**
     * @return type�� �����մϴ�.
     */
    public int getType()
    {
        return type;
    }
    /**
     * @param type �����Ϸ��� type.
     */
    public void setType(int type)
    {
        this.type = type;
    }
    /**
     * @return approvalStep�� �����մϴ�.
     */
    public int getApprovalStep()
    {
        return approvalStep;
    }
    /**
     * @param approvalStep �����Ϸ��� approvalStep.
     */
    public void setApprovalStep(int approvalStep)
    {
        this.approvalStep = approvalStep;
    }
    /**
     * @return uPMU_TYPE�� �����մϴ�.
     */
    public String getUPMU_TYPE()
    {
        return UPMU_TYPE;
    }
    /**
     * @param upmu_type �����Ϸ��� uPMU_TYPE.
     */
    public void setUPMU_TYPE(String upmu_type)
    {
        UPMU_TYPE = upmu_type;
    }
    /**
     * @return modefy�� �����մϴ�.
     */
    public boolean isModefy()
    {
        return modefy;
    }
    /**
     * @param modefy �����Ϸ��� modefy.
     */
    public void setModefy(boolean modefy)
    {
        this.modefy = modefy;
    }
    /**
     * @return relation�� �����մϴ�.
     */
    public int getRelation()
    {
        return relation;
    }
    /**
     * @param relation �����Ϸ��� relation.
     */
    public void setRelation(int relation)
    {
        this.relation = relation;
    }
    /**
     * @return aPPR_SEQN�� �����մϴ�.
     */
    public String getAPPR_SEQN()
    {
        return APPR_SEQN;
    }
    /**
     * @param appr_seqn �����Ϸ��� aPPR_SEQN.
     */
    public void setAPPR_SEQN(String appr_seqn)
    {
        APPR_SEQN = appr_seqn;
    }
    /**
     * @return aPPU_TYPE�� �����մϴ�.
     */
    public String getAPPU_TYPE()
    {
        return APPU_TYPE;
    }
    /**
     * @param appu_type �����Ϸ��� aPPU_TYPE.
     */
    public void setAPPU_TYPE(String appu_type)
    {
        APPU_TYPE = appu_type;
    }
    
    /**
     * @return hasCancel�� �����մϴ�.
     */
    public boolean isHasCancel()
    {
        return hasCancel;
    }
    /**
     * @param hasCancel �����Ϸ��� hasCancel.
     */
    public void setHasCancel(boolean hasCancel)
    {
        this.hasCancel = hasCancel;
    }
    /**
     * @return docStat�� �����մϴ�.
     */
    public int getDocStat()
    {
        return docStat;
    }
    /**
     * @param docStat �����Ϸ��� docStat.
     */
    public void setDocStat(int docStat)
    {
        this.docStat = docStat;
    }
}
