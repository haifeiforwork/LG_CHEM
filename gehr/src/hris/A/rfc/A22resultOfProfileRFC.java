package hris.A.rfc;

import com.common.Utils;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.A.A22resultOfProfileData;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
 * A22resultOfProfileRFC.java
 * 임원 profile 3개년 평가 결과 조회하는 RFC를 호출하는 Class
 *
 * @author 이지은
 * @version 1.0, 2016/06/01 [CSR ID:3089281] 임원 1Page 프로파일 시스템 개발 요청의 건.
 * 2017/09/08  [CSR ID:3460886] 임원 프로파일 시스템 수정 요청의 건.
 */
public class A22resultOfProfileRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_IMWON_PROFILE_NEW";

    public Map<String, Vector> getProfile( String I_PERNR ) throws GeneralException {

        JCO.Client mConnection = null;

        Map<String, Vector> resultMap = new HashMap();

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);

            excute(mConnection, function);

            resultMap.put("getInfo", Utils.asVector(getStructor(new A22resultOfProfileData(), function, "E_INFO"))); //임원 profile 기본정보 조회
            resultMap.put("getResult3Year", Utils.asVector(getStructor(new A22resultOfProfileData(), function, "E_MBOAP"))); //임원 profile 평가 조회

            resultMap.put("getPersInfoS", getTable(A22resultOfProfileData.class, function, "S_LINES")); //임원 profile 성과 조회
            resultMap.put("getPersInfoW", getTable(A22resultOfProfileData.class, function, "W_LINES")); //임원 profile 리더십 조회

            resultMap.put("getBusiness", getTable(A22resultOfProfileData.class, function, "T_BUSI")); //임원 profile 사업가후보 조회
            resultMap.put("getPunish", getTable(A22resultOfProfileData.class, function, "T_PUNISH")); //임원 profile 징계를 조회
            resultMap.put("getEdu", getTable(A22resultOfProfileData.class, function, "T_EDU")); //임원 profile 교육 조회
            resultMap.put("getRole", getTable(A22resultOfProfileData.class, function, "T_ROLE")); //임원 profile 역할 조회
            //resultMap.put("getCareer", getTable(A22resultOfProfileData.class, function, "T_CAREER")); //임원 profile 경력 조회

            resultMap.put("getSchool", getTable(A22resultOfProfileData.class, function, "T_SCHOOL")); //임원 profile 학력 조회
            resultMap.put("getLang", getTable(A22resultOfProfileData.class, function, "T_LANG")); //임원 profile 어학 조회

            resultMap.put("getAction", getTable(A22resultOfProfileData.class, function, "T_ACTION")); //임원 profile 발령 조회
            resultMap.put("getSPlan", getTable(A22resultOfProfileData.class, function, "T_SPLAN")); //임원 profile Success plan 조회
            
            resultMap.put("getSPlanPost", getTable(A22resultOfProfileData.class, function, "T_SPLAN2")); //임원 profile Success plan 현 Post 조회 [CSR ID:3460886]




            return resultMap;

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

    }

}

