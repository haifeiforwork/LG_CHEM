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
 * �ӿ� profile 3���� �� ��� ��ȸ�ϴ� RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2016/06/01 [CSR ID:3089281] �ӿ� 1Page �������� �ý��� ���� ��û�� ��.
 * 2017/09/08  [CSR ID:3460886] �ӿ� �������� �ý��� ���� ��û�� ��.
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

            resultMap.put("getInfo", Utils.asVector(getStructor(new A22resultOfProfileData(), function, "E_INFO"))); //�ӿ� profile �⺻���� ��ȸ
            resultMap.put("getResult3Year", Utils.asVector(getStructor(new A22resultOfProfileData(), function, "E_MBOAP"))); //�ӿ� profile �� ��ȸ

            resultMap.put("getPersInfoS", getTable(A22resultOfProfileData.class, function, "S_LINES")); //�ӿ� profile ���� ��ȸ
            resultMap.put("getPersInfoW", getTable(A22resultOfProfileData.class, function, "W_LINES")); //�ӿ� profile ������ ��ȸ

            resultMap.put("getBusiness", getTable(A22resultOfProfileData.class, function, "T_BUSI")); //�ӿ� profile ������ĺ� ��ȸ
            resultMap.put("getPunish", getTable(A22resultOfProfileData.class, function, "T_PUNISH")); //�ӿ� profile ¡�踦 ��ȸ
            resultMap.put("getEdu", getTable(A22resultOfProfileData.class, function, "T_EDU")); //�ӿ� profile ���� ��ȸ
            resultMap.put("getRole", getTable(A22resultOfProfileData.class, function, "T_ROLE")); //�ӿ� profile ���� ��ȸ
            //resultMap.put("getCareer", getTable(A22resultOfProfileData.class, function, "T_CAREER")); //�ӿ� profile ��� ��ȸ

            resultMap.put("getSchool", getTable(A22resultOfProfileData.class, function, "T_SCHOOL")); //�ӿ� profile �з� ��ȸ
            resultMap.put("getLang", getTable(A22resultOfProfileData.class, function, "T_LANG")); //�ӿ� profile ���� ��ȸ

            resultMap.put("getAction", getTable(A22resultOfProfileData.class, function, "T_ACTION")); //�ӿ� profile �߷� ��ȸ
            resultMap.put("getSPlan", getTable(A22resultOfProfileData.class, function, "T_SPLAN")); //�ӿ� profile Success plan ��ȸ
            
            resultMap.put("getSPlanPost", getTable(A22resultOfProfileData.class, function, "T_SPLAN2")); //�ӿ� profile Success plan �� Post ��ȸ [CSR ID:3460886]




            return resultMap;

        } catch(Exception ex) {
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

    }

}

