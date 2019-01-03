package hris.common.rfc;

import com.common.Utils;
import com.common.constant.Server;
import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.sap.SAPWrap;
import hris.common.EmpData;
import hris.common.WebUserData;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.Predicate;
import org.apache.commons.lang.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.util.Vector;

/**
 * EmpListRFC.java
 * 최초 접속시 국내서버로
     본 RFC를 CALL 하여 사원리스트를 산출하고
     MOLGA 에 따라 해당 서버에 접속 바람
     (MOLGA = '41' -> 국내서버
     그 외 -> 해외서버)
 *
 * @author 정진만
 * @version 1.0, 2016/08/10
 */
public class EmpListRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_EMP_LIST";

    public EmpListRFC() {
        super();
    }

    public EmpListRFC(SAPType sapType) {
        super(sapType);
    }
    public EmpListRFC(SAPType sapType, Server server) {
        super(sapType, server);
    }

    public Vector<EmpData> getEmpList(String I_PERNR) throws GeneralException {
        return getEmpList(I_PERNR, null);
    }

    public Vector<EmpData> getEmpList(String I_PERNR, String I_RETIR) throws GeneralException {

        JCO.Client mConnection = null;
        Vector<EmpData> resultList = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_PERNR", I_PERNR);
            if(StringUtils.isNotBlank(I_RETIR)) setField(function, "I_RETIR", I_RETIR);

            excute(mConnection, function);

            resultList = getTable(EmpData.class, function, "T_LIST");

        } catch(Exception ex) {
            Logger.error(ex);
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }

        return resultList;

    }

    public EmpData findEmpData(Vector<EmpData> empList, final String PERNR) {
        return (EmpData) CollectionUtils.find(empList, new Predicate() {
            public boolean evaluate(Object o) {
                return StringUtils.equals(PERNR, ((EmpData) o).PERNR);
            }
        });
    }

    public boolean setSapTypeFromParameter(HttpServletRequest request, WebUserData user) throws GeneralException {
        /*
        1. Parameter 전달 내역(sys-id)
                -  0  : 국내 ERP (e-HR 관련)
                -  1  : 해외 ERP (e-HR  관련)
                -  2  : 지사 HR
                */
        String sysid = request.getParameter("sysid");

        Logger.debug("=== setSapTypeFromParameter sysid : " + sysid);

        if(StringUtils.isNotBlank(sysid)) {
            if("0".equals(sysid)) user.sapType = SAPType.LOCAL;
            else if("1".equals(sysid)) user.sapType = SAPType.GLOBAL;
            else return false;
        } else {
            return setSapType(request, user, Server.DEFAULT);
        }

        return true;
    }

    public boolean setSapType(HttpServletRequest request, WebUserData user) throws GeneralException{
        return setSapType(request, user, Server.DEFAULT);
    }

    public boolean setSapType(HttpServletRequest request, WebUserData user, Server server) throws GeneralException {
        //sap연결 정보 셋팅
        Vector<EmpData> empList = getEmpList(user.empNo);

        return setSapType(request,user, server, empList);
    }

    public boolean setSapType(HttpServletRequest request, WebUserData user, Server server, Vector<EmpData> empList) throws GeneralException {
        //sap연결 정보 셋팅
        EmpData empData = findEmpData(empList, user.empNo) ;
        Logger.debug("------ empList --------- : " + empList );
        if(empData != null) {
            SAPType sapType;
            if("1".equals(empData.PFLAG)) {
                if(server == Server.DEV) sapType = SAPType.DEVLOCAL;
                else if(server == Server.QAS) sapType = SAPType.QASLOCAL;
                else if(server == Server.PRD) sapType = SAPType.PRDLOCAL;
                else if(server == Server.QASN) sapType = SAPType.QASNLOCAL;
                else if(server == Server.QASN1) sapType = SAPType.QASN1LOCAL;
                else if(server == Server.QASN2) sapType = SAPType.QASN2LOCAL;
                else if(server == Server.QASN3) sapType = SAPType.QASN3LOCAL;
                else if(server == Server.QASN4) sapType = SAPType.QASN4LOCAL;
                else sapType = SAPType.LOCAL;
            } else {
                if(server == Server.DEV) sapType = SAPType.DEVGLOBAL;
                else if(server == Server.QAS) sapType = SAPType.QASGLOBAL;
                else if(server == Server.PRD) sapType = SAPType.PRDGLOBAL;
                else if(server == Server.QASN) sapType = SAPType.QASNGLOBAL;
                else if(server == Server.QASN1) sapType = SAPType.QASN1GLOBAL;
                else if(server == Server.QASN2) sapType = SAPType.QASN2GLOBAL;
                else if(server == Server.QASN3) sapType = SAPType.QASN3GLOBAL;
                else if(server == Server.QASN4) sapType = SAPType.QASN4GLOBAL;
                else sapType = SAPType.GLOBAL;
            }
            user.sapType = sapType;
            return true;
        }

        return false;
    }

    /**
     * Eloffice 전송을 위한 사번 -
     * @param pernr
     * @return
     */
    public String getElofficePERNR(String pernr) {

        try {

            /*현재 접속 대상이 국내 일 경우*/
            if(g.getSapType().isLocal()) return pernr;

            Vector<EmpData> empList = getEmpList(pernr, "X");

            /* 2건 미만이면 리턴값 */
            if(Utils.getSize(empList) < 2) return pernr;

            // 2건 이상이면 PFLAG 값이 2가 아닌 사번을 던진다
            for(EmpData row : empList) {
                if(!"2".equals(row.PFLAG)) return row.PERNR;
            }
        } catch (GeneralException e) {
            Logger.error(e);
        }


        return pernr;
    }

}

