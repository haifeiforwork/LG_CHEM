package hris.common;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-30.
 */
public class UpmuCode extends EntityData {

    public String 	UPMU_TYPE	;//	업무구분	CHAR	3	0	ZUPMU_TYPE
    public String 	UPMU_NAME	;//	업무구분 텍스트	CHAR	30	0	ZUPMU_NAME

    public String getUPMU_TYPE() {
        return UPMU_TYPE;
    }

    public void setUPMU_TYPE(String UPMU_TYPE) {
        this.UPMU_TYPE = UPMU_TYPE;
    }

    public String getUPMU_NAME() {
        return UPMU_NAME;
    }

    public void setUPMU_NAME(String UPMU_NAME) {
        this.UPMU_NAME = UPMU_NAME;
    }
}
