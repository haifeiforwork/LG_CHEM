package hris.common;

import com.sns.jdf.EntityData;

/**
 * Created by manyjung on 2016-08-10.
 */
public class EmpData extends EntityData {

    public String 	PERNR	;//	NUMC	8	사원 번호
    public String 	ENAME	;//	CHAR	40	성명
    public String 	ORGEH	;//	NUMC	8	조직 단위
    public String 	ORGTX	;//	CHAR	40	소속명
    public String 	MOLGA	;//	CHAR	2	국가 그루핑
    public String 	MLGTX	;//	CHAR	25	HR 국가그룹핑 이름
    public String 	PFLAG	;//	CHAR	1	입력 사원번호 FLAG  국내RFC : "1" 국내,  해외 RFC : "2" : 해외사번

}
