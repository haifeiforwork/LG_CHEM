/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ް���������                                                		*/
/*   Program Name : �ް���������                                                		*/
/*   Program ID   : D04VocationDetailSV_m                                       */
/*   Description  : ������ �ް���Ȳ ������ jsp�� �Ѱ��ִ� class                 		*/
/*   Note         :                                                             */
/*   Creation     : 2002-01-21  chldudgh                                        */
/*   Update       : 2005-01-24  ������                                          		*/
/*                : 2005-12-21  @v1.1 lsa C2005122101000000223 2005�⵵ ����ϼ��� �ȳ�Ÿ�� */
/*   	          : [CSR ID:2797167] �ް����� ��� �� ȭ�� �߰���û					*/
/*                : 2015-12-23 [CSR ID:2945528] �ް��������� ȭ�� ���� 			*/
/*                : 2018-07-24 ��ȯ�� [Worktime52] �����ް� �߰��� �� 				*/
/*                                                                              */
/********************************************************************************/

package servlet.hris.D.D04Vocation;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.servlet.Box;
import com.sns.jdf.servlet.EHRBaseServlet;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

import hris.D.D03Vocation.D03VacationUsedData;
import hris.D.D03Vocation.rfc.D03GetWorkdayOfficeRFC;
import hris.D.D03Vocation.rfc.D03VacationUsedRFC;
import hris.D.rfc.D04VocationDetailOfficeRFC;
import hris.common.EmpGubunData;
import hris.common.WebUserData;
import hris.common.rfc.GetEmpGubunRFC;

public class D04VocationDetailSV_m extends EHRBaseServlet {

    protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
    {
        try{

            HttpSession session = req.getSession(false);
            WebUserData user_m = WebUtil.getSessionMSSUser(req);

            String jobid_m = "";
            String dest = "";

            WebUserData user = WebUtil.getSessionUser(req);
//          @����༺ �߰�
            if(!checkAuthorization(req, res)) return;

            Box box = WebUtil.getBox(req);
            jobid_m = box.get("jobid_m");

            if( jobid_m.equals("") ){
                jobid_m = "first";
            }
            
            // ����ٹ� ���а�
            String EMPGUB = "";
            GetEmpGubunRFC empGubunRFC = new GetEmpGubunRFC();
            Vector<EmpGubunData> tpInfo = empGubunRFC.getEmpGubunData(user_m.empNo);
            if(empGubunRFC.getReturn().isSuccess()) EMPGUB = tpInfo.get(0).getEMPGUB();
            req.setAttribute("EMPGUB", EMPGUB);
            
            if( jobid_m.equals("first") ) {

                String year  = DataUtil.getCurrentDate().substring(0,4);
                Logger.debug.println(this, "���糯¥ = "+year);

                // [CSR ID:2945528] �ް��������� ȭ�� ����
                String monthDay = DataUtil.getCurrentDate().substring(4,8);
                Logger.debug.println(this, "���� ���� = "+monthDay);
                if(Integer.parseInt(monthDay) >= Integer.parseInt("1221")){
                	year = DataUtil.getAfterYear(DataUtil.getCurrentDate(), 1).substring(0,4);
                	Logger.debug.println(this, "����⵵ = "+year);
                }

                D04VocationDetailOfficeRFC rfc = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   rfcVacation = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();
                D03VacationUsedData  data                = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt      = new Object();
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String E_ABRTG      = "";
                String FLEXIBLE ="";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {
                    Logger.debug.println(this, "[jobid_m] = "+jobid_m + " [user_m] : "+user_m.toString());

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );

                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// ���ٿ�����
                    LONG_SERVICE = (String) ret.get(1);		// �ټӳ�����
                    FLEXIBLE = (String) ret.get(2);			// �����ް���
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// �ް��߻�
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// �ް����
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// �ް��߻�-�����ο�
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// �ް��߻�-�����������ް�
                    E_COMPTIME = (String) ret.get(8);		// �����ް���
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// �ް��߻�-�����ް�
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// �ް����-�����ް�
                    
                    if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                        D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    else
                        D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );

                } // if ( user_m != null ) end
                
                Logger.debug.println(this, "�ް��߻����� : "+ d04VocationDetail1Data_vt.toString());
                Logger.debug.println(this, "�ް���볻�� : "+ d04VocationDetail2Data_vt.toString());
                Logger.debug.println(this, "�����ο��ް����� : "+ d04VocationDetail3Data_vt.toString());
                Logger.debug.println(this, "���ٿ��� : "+ NON_ABSENCE.toString());
                Logger.debug.println(this, "�ټӿ��� : "+ LONG_SERVICE.toString());
                Logger.debug.println(this, "�ϰ��ް� �ϼ� : " + E_ABRTG.toString());
                Logger.debug.println(this, "�ϰ��ް����� : "+ d03VacationUsedData_vt.toString());
                Logger.debug.println(this, "�����ް� : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 �����ް���
                Logger.debug.println(this, "�����ް� : "+ E_COMPTIME.toString());
                Logger.debug.println(this, "�����ް��߻����� : "+ d04VocationDetail5Data_vt.toString());
                Logger.debug.println(this, "�����ް���볻�� : "+ d04VocationDetail6Data_vt.toString());

                req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                req.setAttribute("year", year);
                req.setAttribute("E_ABRTG", E_ABRTG);
                req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 �����ް���
                req.setAttribute("E_COMPTIME", E_COMPTIME);
                req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);

                dest = WebUtil.JspURL+"D/D04VocationDetail_m.jsp";

            }else if(jobid_m.equals("search")){

                String year  = box.get("year");
                Logger.debug.println(this, "�����ѳ�¥ : "+ year);
                D04VocationDetailOfficeRFC rfc           = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   	   rfcVacation   = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func          = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt = new Object();
                String E_ABRTG ="";
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );
                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// ���ٿ�����
                    LONG_SERVICE = (String) ret.get(1);		// �ټӳ�����
                    FLEXIBLE = (String) ret.get(2);			// �����ް���
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// �ް��߻�
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// �ް����
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// �ް��߻�-�����ο�
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// �ް��߻�-�����������ް�
                    E_COMPTIME = (String) ret.get(8);		// �����ް���
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// �ް��߻�-�����ް�
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// �ް����-�����ް�

                    // 2004.09.08 �߰� ���� ///////////////////////////////////////////////////////////
                    String curr_year = DataUtil.getCurrentYear();

                    if ( year.equals( curr_year) ) {  //@v1.2
                        if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                        else
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );
                    } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C");
                    } else {
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    }
                    // 2004.09.08 �߰� ���� ///////////////////////////////////////////////////////////

                } // if ( user_m != null ) end

                Logger.debug.println(this, "�ް��߻����� : "+ d04VocationDetail1Data_vt.toString());
                Logger.debug.println(this, "�ް���볻�� : "+ d04VocationDetail2Data_vt.toString());
                Logger.debug.println(this, "�����ο��ް����� : "+ d04VocationDetail3Data_vt.toString());
                Logger.debug.println(this, "���ٿ��� : "+ NON_ABSENCE.toString());
                Logger.debug.println(this, "�ټӿ��� : "+ LONG_SERVICE.toString());
                Logger.debug.println(this, "�ϰ��ް� �ϼ� : " + E_ABRTG.toString());
                Logger.debug.println(this, "�ϰ��ް����� : "+ d03VacationUsedData_vt.toString());
                Logger.debug.println(this, "�����ް� : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 �����ް���
                Logger.debug.println(this, "�����ް� : "+ E_COMPTIME.toString());
                Logger.debug.println(this, "�����ް��߻����� : "+ d04VocationDetail5Data_vt.toString());
                Logger.debug.println(this, "�����ް���볻�� : "+ d04VocationDetail6Data_vt.toString());

                req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                req.setAttribute("year", year);
                req.setAttribute("E_ABRTG", E_ABRTG);
                req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 �����ް���
                req.setAttribute("E_COMPTIME", E_COMPTIME);
                req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);

                dest = WebUtil.JspURL+"D/D04VocationDetail_m.jsp?jobid_m=search";

//             [CSR ID:2797167] �ް���ǥ ����˾� �߰� start
            }else if(jobid_m.equals("kubya_1")){
                String year   = box.get("year");
                req.setAttribute( "print_page_name", WebUtil.ServletURL+"hris.D.D04Vocation.D04VocationDetailSV_m?jobid_m=kubya&year="+year);  // 5�� 21�� ���� �߰�
                dest = WebUtil.JspURL+"common/printFrame.jsp";

            }else if(jobid_m.equals("kubya")){

                String year  = box.get("year");
                Logger.debug.println(this, "�����ѳ�¥ : "+ year);
                D04VocationDetailOfficeRFC rfc                 = new D04VocationDetailOfficeRFC();
                D03VacationUsedRFC   	   rfcVacation         = new D03VacationUsedRFC();
                D03GetWorkdayOfficeRFC     func                = new D03GetWorkdayOfficeRFC();

                D03VacationUsedData  d03VacationUsedData = new D03VacationUsedData();

                Vector ret = null;
                
                Vector d04VocationDetail1Data_vt = new Vector();
                Vector d04VocationDetail2Data_vt = new Vector();
                Vector d04VocationDetail3Data_vt = new Vector();
                Vector d04VocationDetail4Data_vt = new Vector();
                Vector d03VacationUsedData_vt    = new Vector();
                Object D03GetWorkdayData_vt = new Object();
                String E_ABRTG ="";
                String NON_ABSENCE  = "";
                String LONG_SERVICE = "";
                String FLEXIBLE = "";
                
                String E_COMPTIME = "";
                Vector d04VocationDetail5Data_vt = new Vector();
                Vector d04VocationDetail6Data_vt = new Vector();

                if ( user_m != null ) {

                    E_ABRTG = rfcVacation.getE_ABRTG(user_m.empNo);

                    d03VacationUsedData_vt = ( new D03VacationUsedRFC() ).getVacationUsed( user_m.empNo );
                    for( int i = 0; i < d03VacationUsedData_vt.size(); i++ ){
                        D03VacationUsedData data = (D03VacationUsedData)d03VacationUsedData_vt.get(i);
                        d03VacationUsedData = data;
                    }
                    
                    ret = rfc.getVocationDetail(user_m.empNo, year);
                    
                    NON_ABSENCE = (String) ret.get(0);		// ���ٿ�����
                    LONG_SERVICE = (String) ret.get(1);		// �ټӳ�����
                    FLEXIBLE = (String) ret.get(2);			// �����ް���
                    d04VocationDetail1Data_vt = (Vector) ret.get(3);	// �ް��߻�
                    d04VocationDetail2Data_vt = (Vector) ret.get(4);	// �ް����
                    d04VocationDetail3Data_vt = (Vector) ret.get(6);	// �ް��߻�-�����ο�
                    d04VocationDetail4Data_vt = (Vector) ret.get(7);	// �ް��߻�-�����������ް�
                    E_COMPTIME = (String) ret.get(8);		// �����ް���
                	d04VocationDetail5Data_vt = (Vector) ret.get(9);	// �ް��߻�-�����ް�
                	d04VocationDetail6Data_vt = (Vector) ret.get(10);	// �ް����-�����ް�
                	
                    // 2004.09.08 �߰� ���� ///////////////////////////////////////////////////////////
                    String curr_year = DataUtil.getCurrentYear();

                    if ( year.equals( curr_year) ) {  //@v1.2
                        if (Long.parseLong(DataUtil.getCurrentDate().substring(4,8)) > 1220)
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                        else
                            D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C" );
                    } else if ( Integer.parseInt(year) >Integer.parseInt(curr_year) ){
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, DataUtil.getCurrentDate(), "C");
                    } else {
                      D03GetWorkdayData_vt = func.getWorkday( user_m.empNo, year+"1220", "C" );
                    }
                    // 2004.09.08 �߰� ���� ///////////////////////////////////////////////////////////

                } // if ( user_m != null ) end

                Logger.debug.println(this, "�ް��߻����� : "+ d04VocationDetail1Data_vt.toString());
                Logger.debug.println(this, "�ް���볻�� : "+ d04VocationDetail2Data_vt.toString());
                Logger.debug.println(this, "�����ο��ް����� : "+ d04VocationDetail3Data_vt.toString());
                Logger.debug.println(this, "���ٿ��� : "+ NON_ABSENCE.toString());
                Logger.debug.println(this, "�ټӿ��� : "+ LONG_SERVICE.toString());
                Logger.debug.println(this, "�ϰ��ް� �ϼ� : " + E_ABRTG.toString());
                Logger.debug.println(this, "�ϰ��ް����� : "+ d03VacationUsedData_vt.toString());
                Logger.debug.println(this, "�����ް� : "+ FLEXIBLE.toString());//@rdcamel 2016.12.15 �����ް���
                Logger.debug.println(this, "�����ް� : "+ E_COMPTIME.toString());
                Logger.debug.println(this, "�����ް��߻����� : "+ d04VocationDetail5Data_vt.toString());
                Logger.debug.println(this, "�����ް���볻�� : "+ d04VocationDetail6Data_vt.toString());

                req.setAttribute("d04VocationDetail1Data_vt", d04VocationDetail1Data_vt);
                req.setAttribute("d04VocationDetail2Data_vt", d04VocationDetail2Data_vt);
                req.setAttribute("d04VocationDetail3Data_vt", d04VocationDetail3Data_vt);
                req.setAttribute("d04VocationDetail4Data_vt", d04VocationDetail4Data_vt);
                req.setAttribute("NON_ABSENCE", NON_ABSENCE);
                req.setAttribute("LONG_SERVICE", LONG_SERVICE);
                req.setAttribute("year", year);
                req.setAttribute("E_ABRTG", E_ABRTG);
                req.setAttribute("d03VacationUsedData_vt", d03VacationUsedData_vt);
                req.setAttribute("D03GetWorkdayData_vt", D03GetWorkdayData_vt);
                req.setAttribute("FLEXIBLE", FLEXIBLE);//@rdcamel 2016.12.15 �����ް���
                req.setAttribute("E_COMPTIME", E_COMPTIME);
                req.setAttribute("d04VocationDetail5Data_vt", d04VocationDetail5Data_vt);
                req.setAttribute("d04VocationDetail6Data_vt", d04VocationDetail6Data_vt);

                dest = WebUtil.JspURL+"D/D04VocationDetail_m_print.jsp?jobid_m=search";
            }

            Logger.debug.println(this, " destributed = " + dest);
            printJspPage(req, res, dest);

        } catch(Exception e) {
            throw new GeneralException(e);
        }
    }
}