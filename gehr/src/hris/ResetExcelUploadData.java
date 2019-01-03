package hris;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-12-29.
 */
public class ResetExcelUploadData extends EntityData {

    public String AINF_SEQN;
    public String PERNR;

    public ResetExcelUploadData() {
    }

    public ResetExcelUploadData(String AINF_SEQN, String PERNR) {
        this.AINF_SEQN = AINF_SEQN;
        this.PERNR = PERNR;
    }

    public String getAINF_SEQN() {
        return AINF_SEQN;
    }

    public void setAINF_SEQN(String AINF_SEQN) {
        this.AINF_SEQN = AINF_SEQN;
    }

    public String getPERNR() {
        return PERNR;
    }

    public void setPERNR(String PERNR) {
        this.PERNR = PERNR;
    }
}
