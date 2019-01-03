/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޴�                                                        */
/*   Program Name : �޴�                                                        */
/*   Program ID   : SysAuthGroupRFC.java                                        */
/*   Description  : �޴� ��� ��������                                          */
/*   Note         : [���� RFC] : ZHRC_RFC_GET_AUTHGROUP                         */
/*   Creation     : 2007-04-16  lsa                                             */
/*   Update       : CSR ID:C20140106_63914    */
/*                                                                              */
/********************************************************************************/

package hris.sys.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.sys.SysAuthInput;

public class SysAuthRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_CHECK_BELONG";

    /**
     * �α����� ����� ���μ�/����� ��ȸ�� ������ �մ��� ����
     * 
     * @param inputData �Է°�
     * @return
     * @throws GeneralException
     */
    public boolean isAuth(SysAuthInput inputData) throws GeneralException {

        JCO.Client mConnection = null;

        try {
            mConnection = getClient();
            JCO.Function function = createFunction(functionName);

/*
I_CHKGB   CHAR 1  üũ ������
                  1 : ��� , ���� üũ (���� ������)
                  2 : �μ���(������) ���������� , ���(������ ����) üũ
                  3 : ����� ���������� ���� ����(��������) üũ
I_DEPT    NUMC 8  ������ �����ȣ
I_PERNR   NUMC 8  ����� �����ȣ
I_ORGEH   NUMC 8  ��� ����
I_AUTHOR  CHAR 1  ���ѱ׷�
I_RETIR   CHAR 1  ������ ����
I_GUBUN   CHAR 1  �������� ������
I_DATUM   DATS 8  ��������
I_SPRSL   LANG 1  ���
*/
            setFields(function, inputData);

            excute(mConnection, function);

            return "X".equals(getField("E_CHECK", function));

        } catch (Exception ex) {
            Logger.sap.println(this, "SAPException : " + ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}