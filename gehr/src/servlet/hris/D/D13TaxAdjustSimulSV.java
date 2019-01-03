package servlet.hris.D;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.*;
import hris.common.util.*;
import hris.common.db.*;
import hris.common.rfc.*;
import hris.D.*;
import hris.D.rfc.*;
import hris.D.D11TaxAdjust.*;
import hris.D.D11TaxAdjust.rfc.*;

/**
 * D13TaxAdjustSimulSV.java
 * ����������� Simulation �� �� �ֵ��� �ϴ� Class
 *
 * @author �輺��
 * @version 1.0, 2002/01/30
 */
public class D13TaxAdjustSimulSV extends EHRBaseServlet {

    //private String UPMU_TYPE ="";            // ���� ����Ÿ��(�����������)
	protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        //Connection con = null;
        try{
            HttpSession  session          = req.getSession(false);
            WebUserData  user             = (WebUserData)session.getAttribute("user");
            Box          box              = WebUtil.getBox(req);

            String dest       = "";
            String jobid      = "";
            jobid = box.get("jobid");
            if( jobid.equals("") ){
                jobid = "first";
            }

            String targetYear = box.get("targetYear");   //[?????]  targetYear => ��� ������ �ٲ���� ����
            if( targetYear.equals("") ){
                targetYear = ((TaxAdjustFlagData)session.getAttribute("taxAdjust")).targetYear;
            }

            String beginDate  = targetYear+"0101";
            String endDate    = targetYear+"1231";

            D13TaxAdjustSimulRFC   simulRfc          = new D13TaxAdjustSimulRFC();
            D13TaxAdjustSimulation simul             = new D13TaxAdjustSimulation();
            D13TaxAdjustSimulData  simulData         = null;
            D14TaxAdjustData       d14TaxAdjustData  = null;
            D13TaxAdjustData       d13TaxAdjustData  = new D13TaxAdjustData();

            // Simulation
            box.copyToEntity(d13TaxAdjustData);
            Logger.debug.println(this,box.toString());
            Logger.debug.println(this,d13TaxAdjustData.toString());
/*
            d13TaxAdjustData._�ѱ޿�                   = 2800*MANWON;
            d13TaxAdjustData._�������ٷμҵ�         = 2800*MANWON;
            d13TaxAdjustData._�ٷμҵ�ݾ�             = 0*MANWON;
            d13TaxAdjustData._���ذ����������ռҵ�ݾ� = 0*MANWON;
            d13TaxAdjustData._���ܿ�õ�ٷμҵ�ݾ�     = 0*MANWON;
            d13TaxAdjustData._�ⳳ�μ���               = 50*MANWON;

            d13TaxAdjustData._���������Ѿ�             = 650*MANWON;
            d13TaxAdjustData._�ǷẸ���               = 30*MANWON;
            d13TaxAdjustData._��뺸���               = 70*MANWON;
            d13TaxAdjustData._������Ϲ�               = 10*MANWON;
            d13TaxAdjustData._����������             = 10*MANWON;
            d13TaxAdjustData._�Ƿ���Ϲ�               = 123*MANWON;
            d13TaxAdjustData._�Ƿ�������           = 123*MANWON;
            d13TaxAdjustData._�����ڱ�����ݾ�         = 30*MANWON;
            d13TaxAdjustData._�����ڱ����Կ�����       = 10*MANWON;
            d13TaxAdjustData._�����ڱ��������ڻ�ȯ     = 10*MANWON;
            d13TaxAdjustData._��αݹ���               = 100*MANWON;
            d13TaxAdjustData._��α�����               = 0*MANWON;
            d13TaxAdjustData._��������               = 12*MANWON;
            d13TaxAdjustData._����������             = 80*MANWON;
            d13TaxAdjustData._���������߰�             = 100*MANWON;
            d13TaxAdjustData._���������               = 0*MANWON;
            d13TaxAdjustData._���ο���I                = 10*MANWON;
            d13TaxAdjustData._���ο���II               = 10*MANWON;
            d13TaxAdjustData._���ο���                 = 10*MANWON;
            d13TaxAdjustData._�������հ���I            = 10*MANWON;
            d13TaxAdjustData._�������հ���II           = 10*MANWON;
            d13TaxAdjustData._�ſ�ī�����        ;    = 1000*MANWON
            d13TaxAdjustData._�����ڱ����ڻ�ȯ         = 10*MANWON;
            d13TaxAdjustData._�ٷ����ֽ�����           = 10*MANWON;
            d13TaxAdjustData._�����������             = 10*MANWON;
            d13TaxAdjustData._�ܱ����μ����           = 0*MANWON;
            d13TaxAdjustData._�ܱ����μ��̿���         = 0*MANWON;
*/
            // �Ѽҵ�, �Ѻ�����ҵ���� �����͸� ��������
            simulData = (D13TaxAdjustSimulData)simulRfc.detail( user.empNo, beginDate, endDate );
            Logger.debug.println(this,simulData.toString());

            d13TaxAdjustData._�ѱ޿�           = (simulData.O_TOTINCOM.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TOTINCOM)));
            d13TaxAdjustData._�������ٷμҵ� = (simulData.O_TAXGROSS.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TAXGROSS)));
            //d13TaxAdjustData._�ѱ޿�           = 3000 * 10000;// �������ӱ�
            //d13TaxAdjustData._�������ٷμҵ� = 3000 * 10000;// �Ѱ����ҵ�

            // �ùķ��̼� ����
            d14TaxAdjustData = (D14TaxAdjustData)simul.simulate(d13TaxAdjustData);
            Logger.debug.println(this,"�ùķ��̼� ���� ���� : "+d14TaxAdjustData.toString());

            // �⺻������ �߰�����, �Ҽ��������߰� ����Ÿ�� request �� �޾ƿ´�
            d14TaxAdjustData._�⺻����_����       = box.getDouble("_�⺻����_����"      );
            d14TaxAdjustData._�⺻����_�����     = box.getDouble("_�⺻����_�����"    );
            d14TaxAdjustData._�⺻����_�ξ簡��   = box.getDouble("_�⺻����_�ξ簡��"  );
            d14TaxAdjustData._�߰�����_��ο��   = box.getDouble("_�߰�����_��ο��"  );
            d14TaxAdjustData._�߰�����_�����     = box.getDouble("_�߰�����_�����"    );
            d14TaxAdjustData._�߰�����_�γ���     = box.getDouble("_�߰�����_�γ���"    );
            d14TaxAdjustData._�߰�����_�ڳ������ = box.getDouble("_�߰�����_�ڳ������");
//            d14TaxAdjustData._�Ҽ��������߰�����  = box.getDouble("_�Ҽ��������߰�����" );

            d14TaxAdjustData._�޿��Ѿ�            =(simulData.O_GROSS.equals("")    ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_GROSS    )));// �Ѿ�
            d14TaxAdjustData._�ѱ޿�              =(simulData.O_TOTINCOM.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TOTINCOM )));// �������ӱ�
            //d14TaxAdjustData._�������ٷμҵ�ݾ�=(simulData.O_TAXGROSS.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_TAXGROSS )));// �Ѱ����ҵ�
            d14TaxAdjustData._������ҵ�_���ܱٷ� =(simulData.O_NTAXGROSS.equals("")?0:Double.parseDouble(DataUtil.removeComma(simulData.O_NTAXGROSS)));// �Ѻ�����ҵ�
            d14TaxAdjustData._�ⳳ�μ���_���ټ�   =(simulData.O_INCOMTAX.equals("") ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_INCOMTAX )));// �ѱٷμҵ漼
            d14TaxAdjustData._�ⳳ�μ���_�ֹμ�   =(simulData.O_RESTAX.equals("")   ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_RESTAX   )));// ���ֹμ�
            d14TaxAdjustData._�ⳳ�μ���_��Ư��   =(simulData.O_SPTAX.equals("")    ?0:Double.parseDouble(DataUtil.removeComma(simulData.O_SPTAX    )));// ��Ư����
/*
            d14TaxAdjustData._�޿��Ѿ�            = 3000 * 10000;// �Ѿ�
            d14TaxAdjustData._�ѱ޿�              = 3000 * 10000;// �������ӱ�
            d14TaxAdjustData._�������ٷμҵ�ݾ�= 3000 * 10000;// �Ѱ����ҵ�
            d14TaxAdjustData._������ҵ�_���ܱٷ� = 0 * 10000;// �Ѻ�����ҵ�
            d14TaxAdjustData._�ⳳ�μ���_���ټ�   = 500 * 10000;// �ѱٷμҵ漼
            d14TaxAdjustData._�ⳳ�μ���_�ֹμ�   = 1 * 10000;// ���ֹμ�
            d14TaxAdjustData._�ⳳ�μ���_��Ư��   = 2 * 10000;// ��Ư����
*/

            d14TaxAdjustData._���Ѿ� = d14TaxAdjustData._�ѱ޿� - d14TaxAdjustData._�޿��Ѿ� ;

            // �����ҵ�ݾ� ���
            double hap2  = d14TaxAdjustData._�⺻����_����       ;
                   hap2 += d14TaxAdjustData._�⺻����_�����     ;
                   hap2 += d14TaxAdjustData._�⺻����_�ξ簡��   ;
                   hap2 += d14TaxAdjustData._�߰�����_��ο��   ;
                   hap2 += d14TaxAdjustData._�߰�����_�����     ;
                   hap2 += d14TaxAdjustData._�߰�����_�γ���     ;
                   hap2 += d14TaxAdjustData._�߰�����_�ڳ������ ;
//                   hap2 += d14TaxAdjustData._�Ҽ��������߰�����  ;
//                   hap2 += d14TaxAdjustData._Ư��������          ;
                   hap2 += d14TaxAdjustData._���ݺ�������      ;

//            d14TaxAdjustData._�����ҵ�ݾ� = d14TaxAdjustData._�������ٷμҵ�ݾ� - hap2 ;

            // ���������հ� ���       
            double hap4  = d14TaxAdjustData._��������_���ټ� ;
                   hap4 += d14TaxAdjustData._��������_�ֹμ� ;
                   hap4 += d14TaxAdjustData._��������_��Ư�� ;
            d14TaxAdjustData._���������հ� = hap4 ;

            // �ⳳ�μ����հ� ���     
            double hap5  = d14TaxAdjustData._�ⳳ�μ���_���ټ� ;
                   hap5 += d14TaxAdjustData._�ⳳ�μ���_�ֹμ� ;
                   hap5 += d14TaxAdjustData._�ⳳ�μ���_��Ư�� ;
            d14TaxAdjustData._�ⳳ�μ����հ� = hap5 ;

            d14TaxAdjustData._����¡������_���ټ� = d14TaxAdjustData._��������_���ټ� - d14TaxAdjustData._�ⳳ�μ���_���ټ�;
            d14TaxAdjustData._����¡������_�ֹμ� = d14TaxAdjustData._��������_�ֹμ� - d14TaxAdjustData._�ⳳ�μ���_�ֹμ�;
            d14TaxAdjustData._����¡������_��Ư�� = d14TaxAdjustData._��������_��Ư�� - d14TaxAdjustData._�ⳳ�μ���_��Ư��;

            // ����¡�������հ� ���   
            double hap6  = d14TaxAdjustData._����¡������_���ټ� ;
                   hap6 += d14TaxAdjustData._����¡������_�ֹμ� ;
                   hap6 += d14TaxAdjustData._����¡������_��Ư�� ;
            d14TaxAdjustData._����¡�������հ� = hap6 ;


            Logger.debug.println(this,d14TaxAdjustData.toString());
            req.setAttribute( "targetYear"      , targetYear);
            req.setAttribute( "d14TaxAdjustData", d14TaxAdjustData);

            dest = WebUtil.JspURL+"D/D13TaxAdjustSimul.jsp";
            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        } finally {
            //DBUtil.close(con);
        }
	}
}
