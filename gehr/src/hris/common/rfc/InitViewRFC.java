/*
 * �ۼ��� ��¥: 2005. 4. 1.
 *
 * TODO ������ ���Ͽ� ���� ���ø�Ʈ�� �����Ϸ��� �������� �̵��Ͻʽÿ�.
 * â - ȯ�� ���� - Java - �ڵ� ��Ÿ�� - �ڵ� ���ø�Ʈ
 */
package hris.common.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

/**
 * @author �̽���
 *
 */
public class InitViewRFC extends SAPWrap
{
    private String functionName = "ZHRA_RFC_EHR_INIT_SCREEN";

    /**
     * �ʱ� ȭ�� �ڷḣ RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getInitViewData( String i_pernr ,String i_orgeh, String i_authorization ) throws GeneralException {
        
        JCO.Client mConnection = null;
        Vector vcRet = new Vector();
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function ,"I_PERNR"    ,i_pernr);
            setField(function ,"I_ORGEH"    ,i_orgeh);
            setField(function ,"I_AUTHORIZATION" ,i_authorization);
            
            excute(mConnection, function);
            if (getField("E_RETURN" ,function).equals("S")) {
                vcRet.add(getTable("hris.G.G001Approval.ApprovalDocList"    , function ,"T_EXPORTA"));
                vcRet.add(getTable("hris.A.A16Appl.A16ApplListData"         , function ,"T_EXPORTB"));
                vcRet.add(getTable("hris.common.ViewEmpVacationData"        , function ,"T_EXPORTC"));
                vcRet.add(getTable("hris.common.ViewDeptVacationData"       , function ,"T_EXPORTD"));
            } else {
                throw new GeneralException(getField("E_MESSAGE" ,function));
            } // end if
            return vcRet;
        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException ");
            throw new GeneralException(ex.getMessage());
        } finally {
            close(mConnection);
        }
    } 

}
