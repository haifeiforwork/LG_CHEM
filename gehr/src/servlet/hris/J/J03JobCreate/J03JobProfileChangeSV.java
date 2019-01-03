package servlet.hris.J.J03JobCreate;

import java.io.*;
import java.sql.*;
import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

import com.sns.jdf.*;
import com.sns.jdf.util.*;
import com.sns.jdf.servlet.*;

import hris.common.WebUserData;

import hris.J.J01JobMatrix.*;
import hris.J.J01JobMatrix.rfc.*;
import hris.J.J03JobCreate.*;
import hris.J.J03JobCreate.rfc.*;

/**
 * J03JobProfileChangeSV.java
 * Job Profile�� �����Ѵ�. << Job ���� >>
 *
 * @author  �赵��
 * @version 1.0, 2003/06/23
 */
public class J03JobProfileChangeSV extends EHRBaseServlet {
		
		protected void performTask(HttpServletRequest req, HttpServletResponse res) throws GeneralException
		{
				try{

						HttpSession       session        = req.getSession(false);
						WebUserData       user           = (WebUserData)session.getAttribute("user");
						
						Box               box            = WebUtil.getBox(req);

						String            jobid          = box.get("jobid");
						String            i_objid        = box.get("OBJID");            // Objective ID
						String            i_sobid        = box.get("SOBID");            // Job ID
						String            i_pernr        = box.get("PERNR");            // �����ȣ
						String            i_idx          = box.get("IMGIDX");
						String            i_link_chk     = box.get("i_link_chk");           
						String            i_begda        = box.get("BEGDA");
						String            i_Create       = box.get("i_Create");         //����ȭ������ ��ȸ,����ȭ������ menu���� �����ϱ� ���ؼ�
						String            dest           = "";

						if( jobid.equals("") ){
								jobid = "first";
						}
						Logger.debug.println(this, "[jobid] = "+jobid + " [user] : "+user.toString());
						
						req.setAttribute("i_sobid",         i_sobid);         //Job ID
						req.setAttribute("i_pernr",         i_pernr);         //�����ȣ
						req.setAttribute("i_imgidx",        i_idx);
						req.setAttribute("i_link_chk",      i_link_chk);
						req.setAttribute("i_begda",         i_begda);
						req.setAttribute("i_Create",        i_Create);

						if( jobid.equals("first") ) {           //����ó�� ��û ȭ�鿡 ���°��.
                J01JobProfileRFC   rfc            = new J01JobProfileRFC();

                Vector             ret            = new Vector();
								Vector             j01Result_P_vt = new Vector();
								Vector             j01Result_D_vt = new Vector();
								Vector             j03HRT1002_vt  = new Vector();                //���� �� �Է»��� ����(HRT1002)
								Vector             j01Holder_vt   = new Vector();

                String             SOBID_D        = "";
                String             E_STEXT_L      = "";

//              Job Profile ��ȸ
								ret            = rfc.getDetail( i_objid, i_sobid, "99991231" );
		
								j01Result_P_vt = (Vector)ret.get(0);
								j01Result_D_vt = (Vector)ret.get(1);
								SOBID_D        = (String)ret.get(2);            //��з� ID
                E_STEXT_L      = (String)ret.get(3);            //Level Grade

//              ������ ���¿� �°� �־��ش�.
//              Job Holder

								for( int i = 0 ; i < j01Result_P_vt.size() ; i++ ) {
										J01JobProfileData data_P = (J01JobProfileData)j01Result_P_vt.get(i);

										J01PersonsData j01Holder = new J01PersonsData();
										j01Holder.TITEL = data_P.TITEL;
										j01Holder.ENAME = data_P.ENAME;
										j01Holder.BEGDA = DataUtil.removeStructur(data_P.BEGDA, "-");
										j01Holder.PERNR = data_P.PERNR;
										j01Holder.OBJID = data_P.SOBID;

										j01Holder_vt.addElement(j01Holder);
								}
//              �󼼳���
								for( int i = 0 ; i < j01Result_D_vt.size() ; i++ ) {
										J01JobProfileData data_D = (J01JobProfileData)j01Result_D_vt.get(i);

										J03ContentsCreData j03HRT1002 = new J03ContentsCreData();
										j03HRT1002.SUBTY = data_D.SUBTY;                  //���� ����
										j03HRT1002.SEQNO = data_D.SEQNO;                  //����
										j03HRT1002.TLINE = data_D.TLINE;                  //������

										j03HRT1002_vt.addElement(j03HRT1002);
								}

//              Job Profile ����              
                req.setAttribute("i_objid",       i_objid);
								req.setAttribute("j01Holder_vt",  j01Holder_vt);              //Job Holder
								req.setAttribute("j03HRT1002_vt", j03HRT1002_vt);             //�̼�����
                req.setAttribute("SOBID_O",       i_objid);                   //Objectives ID
                req.setAttribute("SOBID_D",       SOBID_D);                   //��з� ID
                req.setAttribute("E_STEXT_L",     E_STEXT_L);                 //Leveling Grade

								dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileChange.jsp";

						} else if( jobid.equals("change") ) {   //���� ����
								J03CUDObjectsRFC   rfc_1000      = new J03CUDObjectsRFC();
								J03CUDRelationsRFC rfc_1001      = new J03CUDRelationsRFC();
								J03CUDContentsRFC  rfc_1002      = new J03CUDContentsRFC();
								J03CUDLevelingRFC  rfc_9618      = new J03CUDLevelingRFC();

								J03ObjectCreData   j03HRP1000    = null;
								J03ObjectCreData   j03HRP1001    = null;
								J03ObjectCreData   j03HRP1002    = null;
								J03ContentsCreData j03HRT1002    = null;

								Vector             j03HRP1000_vt = new Vector();                //������Ʈ ����(HRP1000)
								Vector             j03HRP1001_vt = new Vector();                //���� ����(HRP1001)
								Vector             j03HRP1002_vt = new Vector();                //���� ����(HRP1002)
								Vector             j03HRT1002_vt = new Vector();                //���� �� �Է»��� ����(HRT1002)
								Vector             j01Holder_vt  = new Vector();

//              ���� rfc ���ϰ�
								Vector             ret           = new Vector();
								Vector             j03Message_vt = new Vector();
								String             E_SUBRC       = "";

								int                count         = box.getInt("count");         //Job Holder count
								int                count_L       = box.getInt("count_L");       //Job Leveling Sheet count
								int                count_D       = box.getInt("count_D");       //���� count

//              ������Ʈ ����(HRP1000)
								j03HRP1000       = new J03ObjectCreData();
								j03HRP1000.OTYPE = "T";
								j03HRP1000.OBJID = i_sobid;                                     //Job ID
								j03HRP1000.BEGDA = i_begda;                                     //��������
								j03HRP1000.ENDDA = "99991231";                                  //default "99991231" - ������
								j03HRP1000.SHORT = box.get("SHORT");                            //char 12
								j03HRP1000.STEXT = box.get("STEXT");                            //char 40

								j03HRP1000_vt.addElement(j03HRP1000);
Logger.debug.println(this, "### [HRP1000] : " + j03HRP1000_vt);

								ret           = rfc_1000.Create( user.empNo, j03HRP1000_vt );
								j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
								E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

Logger.debug.println(this, "### [HRP1000]E_SUBRC : " + E_SUBRC);
Logger.debug.println(this, "### [HRP1000]j03Message_vt : " + j03Message_vt);

//              ���� �� �Է»��� ����(HRT1002)
								for( int i = 0 ; i < count_D ; i++ ) {
										String            idx         = Integer.toString(i);

										j03HRT1002       = new J03ContentsCreData();
										j03HRT1002.SUBTY = box.get("SUBTY_D"+idx);                  //���� ����
										j03HRT1002.SEQNO = box.get("SEQNO_D"+idx);                  //����
										j03HRT1002.TLINE = box.get("TLINE_D"+idx);                  //������

										j03HRT1002_vt.addElement(j03HRT1002);
								}

//              ������Ʈ ������ ������ ���
								if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                  ���� ����(HRP1001) -  ��з�(15)
										j03HRP1001       = new J03ObjectCreData();
										j03HRP1001.SUBTY = "AZ12";
										j03HRP1001.RSIGN = "A";
										j03HRP1001.RELAT = "Z12";
										j03HRP1001.SCLAS = "15";
										j03HRP1001.SOBID = box.get("SOBID_D");

										j03HRP1001_vt.addElement(j03HRP1001);
//------------------��з��� ����� ��찡 ������ �����Ƿ� Objectives ID�� �����Ѵ�.
                    i_objid = box.get("SOBID_O");
                    req.setAttribute("i_objid",       i_objid);

//                  ���� ����(HRP1001) -  ������(Job Holder)(S)
										for( int i = 0 ; i < count ; i++ ) {                            
												String            idx         = Integer.toString(i);

												j03HRP1001       = new J03ObjectCreData();
												j03HRP1001.BEGDA = box.get("BEGDA_S"+idx);                  //Job ������
												j03HRP1001.SUBTY = "A007";
												j03HRP1001.RSIGN = "A";
												j03HRP1001.RELAT = "007";
												j03HRP1001.SCLAS = "S";
												j03HRP1001.SOBID = box.get("SOBID_S"+idx);

												j03HRP1001_vt.addElement(j03HRP1001);
										}
//                  ������ ���� �����Ϳ� ���� �����͸� ä���ش�.
										for( int i = 0 ; i < j03HRP1001_vt.size() ; i++ ) {
												J03ObjectCreData data = (J03ObjectCreData)j03HRP1001_vt.get(i);

												data.OTYPE = "T";
												data.OBJID = i_sobid;                                     //default "00000000" - ������
//                      �������� �ƴ� ��� �������ڸ� �����Ͽ� �ݿ��Ѵ�.
												if( !(data.RSIGN.equals("A") && data.RELAT.equals("007") && data.SCLAS.equals("S")) ) {
														data.BEGDA = i_begda;                                 //��������
												}
												data.ENDDA = "99991231";                                  //default "99991231" - ������
										}
Logger.debug.println(this, "### [HRP1001] : " + j03HRP1001_vt);
		
										ret           = rfc_1001.Create( user.empNo, j03HRP1001_vt );
										j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
										E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

Logger.debug.println(this, "### [HRP1001]E_SUBRC : " + E_SUBRC);
Logger.debug.println(this, "### [HRP1001]j03Message_vt : " + j03Message_vt);

										if( E_SUBRC.equals("0") && j03Message_vt.size() == 0 ) {
//                      ���� ����(HRP1002)
												String old_SUBTY = "";
												for( int i = 0 ; i < j03HRT1002_vt.size() ; i++ ) {
														J03ContentsCreData data = (J03ContentsCreData)j03HRT1002_vt.get(i);

//                          ���� �� �Է»��� ����(HRT1002)
														data.OBJID = i_sobid;
														if( !old_SUBTY.equals(data.SUBTY) ) {
																j03HRP1002       = new J03ObjectCreData();
																j03HRP1002.OTYPE = "T";
																j03HRP1002.OBJID = data.OBJID;                              //default "00000000" - ������
																j03HRP1002.BEGDA = i_begda;                                 //��������
																j03HRP1002.ENDDA = "99991231";                              //default "99991231" - ������
																j03HRP1002.SUBTY = data.SUBTY;
				
																j03HRP1002_vt.addElement(j03HRP1002);
		
																old_SUBTY = data.SUBTY;
														}
												}
Logger.debug.println(this, "### [HRP1002] : " + j03HRP1002_vt);
Logger.debug.println(this, "### [HRT1002] : " + j03HRT1002_vt);

												ret           = rfc_1002.Create( user.empNo, j03HRP1002_vt, j03HRT1002_vt );
												j03Message_vt = (Vector)ret.get(0);                          //�۾� ��� �޽���
												E_SUBRC       = (String)ret.get(1);                          //�۾� ��� FLAG

Logger.debug.println(this, "### [HRP1002]E_SUBRC : " + E_SUBRC);
Logger.debug.println(this, "### [HRP1002]j03Message_vt : " + j03Message_vt);

										}       //1002����
								}           //1001����

//              error�� ó���ϱ� ���ؼ� �Է°��� ȭ������ �ٽ� �����ش�.
								if( !E_SUBRC.equals("0") || j03Message_vt.size() > 0 ) {
										req.setAttribute("STEXT",           box.get("STEXT"));          //������Ʈ ��
										req.setAttribute("SOBID_F",         box.get("SOBID_F"));        //Function ID
										req.setAttribute("SOBID_O",         box.get("SOBID_O"));        //Objectives ID
										req.setAttribute("SOBID_D",         box.get("SOBID_D"));        //��з� ID
                    req.setAttribute("E_STEXT_L",       box.get("E_STEXT_L"));      //Leveling Grade
//                  Job Holder
										for( int i = 0 ; i < count ; i++ ) {                            
												J01PersonsData j01Holder = new J01PersonsData();
												String         idx       = Integer.toString(i);
												j01Holder.TITEL = box.get("TITEL_S"+idx);
												j01Holder.ENAME = box.get("ENAME_S"+idx);
												j01Holder.BEGDA = box.get("BEGDA_S"+idx);
												j01Holder.PERNR = box.get("PERNR_S"+idx);
												j01Holder.OBJID = box.get("SOBID_S"+idx);

												j01Holder_vt.addElement(j01Holder);
										}
										req.setAttribute("j01Holder_vt",    j01Holder_vt);              //Job Holder
										req.setAttribute("j03HRT1002_vt",   j03HRT1002_vt);             //������
//                  error �߻� ����
										req.setAttribute("i_error",         "Y");
										req.setAttribute("j03Message_vt",   j03Message_vt);

										dest = WebUtil.JspURL+"J/J03JobCreate/J03JobProfileChange.jsp";
//              ���� ������ ��� Competency Requirments�� �����ϱ����ؼ� ȭ���� �̵��Ѵ�.
								} else {
										String msg = "msg002";
										String url = "location.href = '" + WebUtil.ServletURL+"hris.J.J03JobCreate.J03JobProfileDetailSV?OBJID="+i_objid+"&SOBID="+i_sobid+"&BEGDA="+i_begda+"&IMGIDX=1';";
										req.setAttribute("msg", msg);
										req.setAttribute("url", url);

										dest = WebUtil.JspURL+"common/msg.jsp";
								}
						}
						Logger.debug.println(this, " destributed = " + dest);
						printJspPage(req, res, dest);
							
				} catch (Exception e) {
						throw new GeneralException(e);
				}
		}
}
