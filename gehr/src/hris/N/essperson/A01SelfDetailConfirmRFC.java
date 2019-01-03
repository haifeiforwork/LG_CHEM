/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : �޴�                                                        */
/*   Program Name : �޴�                                                        */
/*   Program ID   :A01SelfDetailConfirmRFC.java                                        */
/*   Description  : �޴� ��� ��������                                          */
/*   Note         : [���� RFC] : A01SelfDetailConfirmRFC                         */
/*   Creation     : 2016 1.1  [CSR ID:2953938] ���� �λ����� Ȯ�α�� ���� �� �ݿ��� ��                                            */
/*   Update       :    */
/*                                                                              */
/********************************************************************************/

package hris.N.essperson;

import com.common.RFCReturnEntity;
import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class A01SelfDetailConfirmRFC extends SAPWrap {

    private String functionName = "ZGHR_INFORMATION_CONFIRM";

    /**
     *
1. IMPORT
PERNR TYPE PERNR-PERNR                       ��� ��ȣ
GUBUN TYPE CHAR01                       'C' = Ȯ�� ����, 'S' = ���� ����
CFLAG TYPE CHAR01                       'Y' = Ȯ�� �Ϸ�

2. EXPORT
CONFIRM TYPE CHAR1 'Y' = Ȯ�� �Ϸ�
 -------------------------------------------------------------------------------
1. Ȯ�� ����� ���� ó��
 : ���(PERNR)�� ������(GUBUN = 'S' )�� ���� �Ѱ��ָ� CONFIRM �ʵ�� RETURN ��
   CONFIRM�� ���� 'Y' �̸� �˾� �������

2. ������ �˾����� Ȯ�� ��ư�� ������ ���
  : ���(PERNR)�� ������(GUBUN = 'C') Ȯ�οϷ�(CFLAG = 'Y')�� ���� �Ѱ��ָ� SAP�� ������Ʈ ��
    MESSAGE �ʵ忡 'Ȯ���� �Ϸ�Ǿ����ϴ�.'�� RETURN ��
 -------------------------------------------------------------------------------
     */
    public String getInsaConfirmTargetCheck(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            /*
            I_PERNR		 NUMC 	 8 	�����ȣ
I_GUBUN		 CHAR 	 1 	������
I_CFLAG		 CHAR 	 1 	Ȯ�οϷ�
             */
            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_GUBUN", "S");

            excute(mConnection, function);

            return getField("E_CONFIRM", function);

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    public RFCReturnEntity setInsaConfirmEnd(String I_PERNR) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField( function, "I_PERNR", I_PERNR );
            setField( function, "I_GUBUN", "C");
            setField( function, "I_CFLAG", "Y");

            excute(mConnection, function);

            return getReturn();

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}
