// Written by Glen Knowles <gknowles@ieee.org>
package com.fileupload;
import java.io.*;
import java.net.*;
import java.util.*;

/** 
 * Simple FTP Client class. Handles basic operations, easily extended to handle
 * additional functions. Only passive mode transfers using file structure and 
 * streaming mode is implemented, restarts are not implemented.
 * <p>Here is a simple example for downloading a file:
 * <pre>
 * FtpClient ftpc = 
 *   new FtpClient("ftp.server.com", "annonymous", "email@mydomain.com");
 * OutputStream os = new FileOutputStream("test.out");
 * ftpc.get("test.out", os);
 * ftpc.close();
 * </pre>
 *
 * @author Glen Knowles, Copyright &#169; 2000
 * @version 1.0, 00/10/06
 */
/*
	여기에 사용하는 FTP Class는 MultipartRequest Class와 함께 사용하기 위한 것입니다.
	물론 이자체로도 완벽한 FTP Client로 사용할 수 있습니다. 원한다면 말이죠.
	만든 사람은 여기 첫 머리에도 적혀 있듯 Glen Knowles <gknowles@ieee.org> 랍니다.	
	밑에는 테스트 용도로 사용해 볼수 있는 코드입니다. 

import java.lang.reflect.*; 
import java.io.*;
import java.net.*;
import java.util.*;
import java.lang.*;

public class FTPManager extends FtpClient {
	
	public FTPManager(String server, String user, String password) throws Exception{
		super(server, user, password);
	}
	
	public boolean doCd(String dir){		
		try{
			cd(dir);
			return true;			
		}catch(Exception e){
			return false;
		}
	}
	
	public boolean doPut(String dir, String fileName, boolean mode ){
		try{
			setAscii(mode);
			File file_in= new File(dir + File.separatorChar + fileName);
			FileInputStream is= new FileInputStream(file_in); 
			put(is, fileName);
			is.close();
			return true;
		}catch(Exception e){
			return false;
		}
	}
	
	public boolean doGet(String dir, String fileName, boolean mode){
		try{
			setAscii(mode);
			if(list(fileName).length == 0) return false;
			File file_out= new File(dir + File.separatorChar + fileName);
			FileOutputStream out= new FileOutputStream(file_out);
			get(fileName, out);
			out.close();
			return true;
		}catch(Exception e){
			return false;
		}	
	}
	
	
	// 이거 테스트 코드임당...
	// 적당히 수정해서 사용하세요.
	public static void main(String [] args) throws Exception{
		FTPManager ftp = new FTPManager("xxxxxx", "xxxxxxx", "xxxxxxx");
		Logger.debug("cd : " + ftp.doCd("xxxxxxxxxxx"));
		Logger.debug("Upload : " +  ftp.doPut(File.separatorChar + "tt", "093539_pl233.jpg", false));
		Logger.debug("Download : " +  ftp.doGet(File.separatorChar + "tt", "ftpsend.sh", false));
		ftp.close();
	}
} 
 
*/ 
public class FtpClient {

  /**
   * Default FTP control port is '21'.
   */
  public static final int DEFAULT_PORT = 21;
  
  private String   d_lastCommand = null;
  private FtpReply d_reply;
  
  // state variables
  private boolean d_isAscii;
  private boolean d_isOpen;
  
  // debug output print writer
  private PrintWriter    d_debugWriter;

  // control port
  private Socket d_csock = null;
  private BufferedReader d_cin;
  private PrintWriter    d_cout;
  
  ///////////////////////////////////////////////
  // CREATE
  ///////////////////////////////////////////////
  /**
   * Constructs FtpClient object with debugging output. <b>debugOut</b> can be 
   * <b>null</b> which disables debugging output.
   *
   * @parm debugOut Output stream that will receive debug info.
   * @see #setDebugOutput setDebugOutput
   */
  public FtpClient(OutputStream debugOut) {
    d_isOpen = false;
    d_reply = new FtpReply();
    setDebugOutput(debugOut);
  }

  /**
   * Construct FtpClient object.
   */
  public FtpClient() {
    this(null);
  }

  /**
   * Convience constructor; creates FtpClient object, opens connection to 
   * <b>server</b> on default port, and logs in. <b>password</b> can be null 
   * but if it is and the server asks for it FtpException is thrown.
   *
   * @parm server Host name or ip of server.
   * @parm user User login name
   * @parm password Login password
   */
  public FtpClient(String server, String user, String password) 
      throws FtpException, IOException {
    this(null);
    open(server, user, password);
  }

  /**
   * Convience constructor; creates FtpClient object, opens connection to 
   * <b>server</b> on default port, and logs in. <b>password</b> can be null 
   * but if it is and the server asks for it FtpException is thrown.
   *
   * @parm address address of server to connect with.
   * @parm user User login name
   * @parm password Login password
   */
  public FtpClient(InetAddress address, String user, String password) 
      throws FtpException, IOException {
    this(null);
    open(address, user, password);
  }

  ///////////////////////////////////////////////
  // DESTROY
  ///////////////////////////////////////////////
  protected void finalize()
      throws Throwable {
    setDebugOutput(null);
    close();
    super.finalize();
  }

  ///////////////////////////////////////////////
  // State Variables
  ///////////////////////////////////////////////
  /**
   * <b>true</b> if debug output is enabled.
   */
  public boolean isDebug() { return (d_debugWriter != null); }
  /**
   * <b>true</b> if connected to FTP server.
   */
  public boolean isOpen() { return d_isOpen; }

  /**
   * Last command string that was sent to server.
   */
  public String   getLastCommand() { return d_lastCommand; }
  /**
   * Last reply received from FTP server. Undefined if no commands have been 
   * sent.
   */ 
  public FtpReply getLastReply() { return d_reply; }

  ///////////////////////////////////////////////
 /**
  * Set output stream that will receive debug output, or set to null
  * to disable. Debug output consists of a complete transcript of the 
  * commands sent and replies received from the FTP server on the control 
  * channel with additional comment lines after some replies (notably 227 
  * and 257) showing how they were interpreted. Commands, replies, and 
  * comments are prefaced with "> ", "< ", and ": " respectively.
  *
  * @parm debugOut OutputStream where debug info will be sent.
  */
  public void setDebugOutput(OutputStream debugOut) {
    if (debugOut == null) d_debugWriter = null;
    else {
      d_debugWriter = new PrintWriter(debugOut, true);
    }
  }
  
  ///////////////////////////////////////////////
  // Connection Functions
  ///////////////////////////////////////////////
  /**
   * Activates connection to FTP server.  Prepares connection for use and
   * reads welcome greeting (220 reply) from server, throws exception if 
   * missing or improper greeting from server.
   *
   * @parm sock Socket connected to FTP server.
   */
  public void open(Socket sock)
      throws FtpException, IOException {
    if (isOpen())
      throw new IllegalStateException("Connection already open");
    if (sock == null) 
      throw new IllegalArgumentException("null sock");
    d_csock = sock;

    // create control streams
    InputStream cis = d_csock.getInputStream();
    d_cin = new BufferedReader(new InputStreamReader(cis));
    OutputStream cos = d_csock.getOutputStream();
    d_cout = new PrintWriter(cos, true); // set auto flush true.
    
    // See if server is alive or dead... 
    parseReply();

    // mark as open
    d_isOpen = true;

    // is server not ready?
    if (d_reply.getCode() != 220) {
      throw new FtpException(d_reply);
    }
  }

  /**
   * Opens connection to FTP server.  Prepares it for use and reads welcome 
   * greeting (220 reply) from server, throws FtpException if missing or 
   * improper greeting from server.
   *
   * @parm server Host name or ip of server.
   * @parm port Port FTP server listens on.
   */
  public void open(String server, int port)
      throws FtpException, IOException {
    if (server == null)
      throw new IllegalArgumentException("null server");

    // create control socket
    Socket sock = new Socket(server, port);
    open(sock);
  }

  /**
   * Opens connection to FTP server using default FTP port.  Prepares 
   * it for use and reads welcome greeting (220 reply) from server, 
   * throws FtpException if missing or improper greeting from server.
   *
   * @parm server Host name or ip of server.
   */
  public void open(String server)
      throws FtpException, IOException {
    open(server, DEFAULT_PORT);
  }

  /**
   * Convience method; opens connection to FTP server on default port and logs
   * in. Throws exception if missing or improper greeting from server, or if 
   * user and password are rejected.
   *
   * @parm server Host name or ip of server.
   * @parm user user login name
   * @parm password login password
   */
  public void open(String server, String user, String password)
      throws FtpException, IOException {
    open(server);
    login(user, password);
  }

  /**
   * Opens connection to FTP server.  Prepares it for use and reads welcome 
   * greeting (220 reply) from server, throws exception if missing or improper 
   * greeting from server.
   *
   * @parm address IP address of server
   * @parm port Port FTP server listens on.
   */
  public void open(InetAddress address, int port) 
      throws FtpException, IOException {
    // create control socket
    Socket sock = new Socket(address, port);
    open(sock);
  }

  /**
   * Opens connection to FTP server using default FTP port.  Prepares 
   * it for use and reads welcome greeting (220 reply) from server, 
   * throws exception if missing or improper greeting from server.
   *
   * @parm address IP address of server
   */
  public void open(InetAddress address) 
      throws FtpException, IOException {
    open(address, DEFAULT_PORT);
  }

  /**
   * Convience method; opens connection to FTP server on default port and logs
   * in. Throws exception if missing or improper greeting from server, or if 
   * user and password are rejected.
   *
   * @parm address IP address of server
   * @parm user user login name
   * @parm password login password
   */
  public void open(InetAddress address, String user, String password)
      throws FtpException, IOException {
    open(address);
    login(user, password);
  }

  /**
   * Login to open FTP server.  <b>password</b> and <b>account</b> may be null, 
   * but if they are and the server asks for them an FtpException will be 
   * thrown.
   *
   * @parm user User login name.
   * @parm password Login password.
   * @parm account additional account information required by some servers.
   */
  public void login(String user, String password, String account) 
      throws FtpException, IOException {
    if (user == null)
      throw new IllegalArgumentException("null user");

    sendCommand("USER " + user);
    if (d_reply.getCode() == 331 && password != null) {
      sendCommand("PASS " + password);
    }
    if (d_reply.getCode() == 332 && account != null) {
      sendCommand("ACCT " + account);
    }
    switch (d_reply.getType()) {
    case FtpReply.RC_PRELIMINARY:
    case FtpReply.RC_INTERMEDIATE:
      throw new FtpException(d_reply);
    }
  }

  /**
   * Login to open FTP server.  <b>password</b> may be null, but if it is and
   * the server asks for it an FtpException will be thrown.
   *
   * @parm user user login name.
   * @parm password login password.
   */
  public void login(String user, String password) 
      throws FtpException, IOException {
    login(user, password, null);
  }

  /**
   * Closes connection to FTP server. Method does nothing if there is no
   * open connection.
   */
  public void close()
      throws IOException {
    if (isOpen()) {
      d_isOpen = false;
      String cmd = "QUIT";
      if (isDebug()) d_debugWriter.println("> " + cmd);
      d_cout.print(cmd + "\r\n");
      d_cout.flush();
      d_cout.close();
      d_cin.close();
      d_csock.close();
    }
  }

  ///////////////////////////////////////////////
  // Directory Functions
  ///////////////////////////////////////////////
  /** 
   * Print working directory, returns the name of the current working
   * directory.
   *
   * @returns Current working directory on server.
   */
  public String pwd()
      throws FtpException, IOException {
    try {
      sendCommand("PWD");
    }
    catch (FtpException e) {
      switch (e.getCode()) {
      default: 
        throw e;
      case 500:
      case 502:
        sendCommand("XPWD");
        break;
      }
    } // catch
    return d_reply.getPath();
  }

  /**
   * Changes working directory. Changes the working directory on the server 
   * relative to the current working directory. If dir is null no action
   * is taken.
   *
   * @parm dir new working directory on server.
   */ 
  public void cd(String dir)
  throws FtpException, IOException {
    if (dir != null) {
      try {
        sendCommand("CWD " + dir); 
      }
      catch (FtpException e) {
        switch (e.getCode()) {
        default: 
          throw e;
        case 500:
        case 502:
          sendCommand("XCWD " + dir);
          break;
        }
      } // catch
    } // if dir != null 
  }

  /**
   * Make new directory on server, returns the full pathname of the created 
   * directory. 
   *
   * @parm dir directory to create on server.
   * @returns full pathname of newly created directory.
   */
  public String mkdir(String dir)
      throws FtpException, IOException {
    if (dir == null)
      throw new IllegalArgumentException("null dir");

    try {
      sendCommand("MKD " + dir);
    }
    catch (FtpException e) {
      switch (e.getCode()) {
      default: 
        throw e;
      case 500:
      case 502:
        sendCommand("XMKD " + dir);
        break;
      }
    } // catch
    return d_reply.getPath();
  }

  /**
   * Removes directory.
   *
   * @parm dir Directory to remove from server.
   */
  public void rmdir(String dir)
      throws FtpException, IOException {
    if (dir == null)
      throw new IllegalArgumentException("null dir");

    try {
      sendCommand("RMD " + dir);
    }
    catch (FtpException e) {
      switch (e.getCode()) {
      default: 
        throw e;
      case 500:
      case 502:
        sendCommand("XRMD " + dir);
        break;
      }
    } // catch
  }

  ///////////////////////////////////////////////
  // Remote File Operations
  ///////////////////////////////////////////////
  /**
   * Deletes file.
   *
   * @parm path Pathname of file to delete.
   */
  public void delete(String path)
      throws FtpException, IOException {
    if (path == null)
      throw new IllegalArgumentException("null path");

    sendCommand("DELE " + path);
    if (d_reply.getType() != FtpReply.RC_COMPLETE) {
      throw new FtpException(d_reply);
    }
  }

  /** 
   * Renames file.
   *
   * @parm srcPath File to rename.
   * @parm dstPath New name.
   */
  public void rename(String srcPath, String dstPath)
      throws FtpException, IOException {
    if (srcPath == null)
      throw new IllegalArgumentException("null srcPath");
    if (dstPath == null)
      throw new IllegalArgumentException("null dstPath");

    sendCommand("RNFR " + srcPath);
    if (d_reply.getType() != FtpReply.RC_INTERMEDIATE) {
      throw new FtpException(d_reply);
    }
    sendCommand("RNTO " + dstPath);
    if (d_reply.getType() != FtpReply.RC_COMPLETE) {
      throw new FtpException(d_reply);
    }
  }

  ///////////////////////////////////////////////
  // File List
  ///////////////////////////////////////////////
  /**
   * Lists files specified by <b>pathname</b>.  If pathname is null a list of
   * the files in the working directory is returned. Lists returned by this 
   * function are not guaranteed to be in any particular order.
   *
   * @parm pathname directory or other file grouping
   * @returns list of files found
   */
  public String[] list(String pathname) 
      throws FtpException, IOException {
    List list = new ArrayList();

    // get input stream
    Socket dsock = getDataSocket();
    BufferedReader is = 
        new BufferedReader(new InputStreamReader(dsock.getInputStream()));
    
    try {
      // request list transfer
      if (pathname == null) sendCommand("NLST");
      else {
        sendCommand("NLST " + pathname);
      }
      
      // preliminary reply?
      if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {

        // transfer the data
        String line;
        while ((line = is.readLine()) != null) {
          list.add(line);
        }
      }
    }
    catch (FtpException e) {
      switch (e.getCode()) {
      case 550: // no files found
        break;
      default: // other error
        throw e;
      }
    }
    finally {
      // close data socket
      is.close();
    }

    // was initial reply preliminary?
    if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
      // get final reply
      parseReply();
    }
    // not a successful completion?
    if (d_reply.getType() != FtpReply.RC_COMPLETE) {
      throw new FtpException(d_reply);
    }

    String[] array = { "" };
    return (String[]) list.toArray(array);
  }

  /**
   * Lists files in working directory.  Lists returned by this function are 
   * not guaranteed to be in any particular order.
   *
   * @parm pathname directory or other file grouping
   * @returns list of files found
   */
  public String[] list() 
      throws FtpException, IOException {
    return list(null);
  }

  ///////////////////////////////////////////////
  // File Transfer
  ///////////////////////////////////////////////
  /**
   * Transfers data in input stream to file named dstPath on server. Will 
   * overwrite an existing file of the same name.
   *
   * @parm in contents to be saved in new file.
   * @parm dstPath name of file being created on server.
   */
  public void put(InputStream in, String dstPath) 
      throws FtpException, IOException {
    if (in == null)
      throw new IllegalArgumentException("null in");
    if (dstPath == null)
      throw new IllegalArgumentException("null dstPath");

    // get output stream: dsock <--
    Socket dsock = getDataSocket();
    try {
      // request file transfer
      sendCommand("STOR " + dstPath);
      // preliminary reply?
      if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
        // transfer the data
        transfer(in, dsock.getOutputStream());
      }
    }
    finally {
      // closing data socket signals end of file to server
      dsock.close();
    }

    // was initial reply preliminary?
    if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
      // get final reply
      parseReply();
    }
    // not a successful completion?
    if (d_reply.getType() != FtpReply.RC_COMPLETE) {
      throw new FtpException(d_reply);
    }
  }

  /**
   * Transfers data from file specified by <b>srcPath</b> on the server to 
   * output stream.
   *
   * @parm srcPath Remote file to transfer data from.
   * @parm out Output stream receiving data.
   */
  ///////////////////////////////////////////////
  public void get(String srcPath, OutputStream out)
      throws FtpException, IOException {
    if (srcPath == null)
      throw new IllegalArgumentException("null srcPath");
    if (out == null)
      throw new IllegalArgumentException("null out");

    // get input stream: dsock -->
    Socket dsock = getDataSocket();
    
    try {
      // request file transfer
      sendCommand("RETR " + srcPath);
      
      // preliminary reply?
      if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
        // transfer the data
        transfer(dsock.getInputStream(), out);
      }
    }
    finally {
      // closing data socket signals end of file to server
      dsock.close();
    }

    // was initial reply preliminary?
    if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
      // get final reply
      parseReply();
    }

    // not a successful completion?
    if (d_reply.getType() != FtpReply.RC_COMPLETE) {
      throw new FtpException(d_reply);
    }
  }

  ///////////////////////////////////////////////
  // Miscellaneous
  ///////////////////////////////////////////////
  /**
   * <b>true</b> if representation type is ASCII, otherwise it is binary.
   *
   * @returns boolean: is representation type ascii?
   */
  public boolean isAscii() { return d_isAscii; }
    
  /**
   * Enables ASCII representation type, if disabled binary is used.
   *
   * @parm enable boolean: enable ascii?
   */
  public void setAscii(boolean enable) 
      throws FtpException, IOException { 
    d_isAscii = enable; 
    sendCommand("TYPE " + (enable ? 'A' : 'I'));
  }

  /**
   * Causes FTP server to process a no op.
   */
  public void noop() 
      throws FtpException, IOException {
    sendCommand("NOOP");
  }

  /**
   * Causes FTP server to process <b>command</b> verbatim. The standard 
   * functions should be used whenever they support the operation required.
   * When using quote keep in mind that it may change the state of the remote
   * server is ways the rest of the FtpClient class doesn't recognize.  For 
   * example, changes to the representation type via <b>quote()</b> would not 
   * be reflected in a subsequent call to <b>isAscii()</b>.
   *
   * @parm command Command text sent to remote server.
   */
  public void quote(String command)
      throws FtpException, IOException {
    if (command == null)
      throw new IllegalArgumentException("null command");
    
    sendCommand(command);
  }
  
  //#############################################
  // PRIVATE
  //#############################################
  /**
   * Sends command to server and reads reply.  If that last reply received
   * was preliminary a reply will be read and discarded prior to sending 
   * the new command.
   *
   * @parm command Command to send to server.
   */
  private void sendCommand(String command) 
      throws FtpException, IOException {
    
    if (!isOpen()) 
      throw new IllegalStateException("FTP control connection closed");
    if (command == null)
      throw new IllegalArgumentException("null command");
    
    if (isDebug()) d_debugWriter.println("> " + command);
    
    d_lastCommand = command;
    if (d_reply.getType() == FtpReply.RC_PRELIMINARY) {
      // last reply was preliminary, get final reply
      // before sending next command
      parseReply();
      }
    d_cout.print(command + "\r\n");
    d_cout.flush(); 
    parseReply();
  }

  /**
   * Query the server for a passive mode port and return a socket connected
   * to it. Exception thrown if the reply doesn't have a 227 reply code.
   *
   * @returns Data socket connected to FTP server.
   */
  private Socket getDataSocket()
    throws FtpException, IOException {
    // Go to PASV mode, capture server reply, parse for socket setup
    // Parse server reply, only depend on presence of commas
    //   "227 Entering Passive Mode (a1,a2,a3,a4,p1,p2)"
    sendCommand("PASV");
    if (d_reply.getCode() != 227) {
      throw new FtpException(d_reply);
    }
    return new Socket(d_reply.getHost(), d_reply.getPort());
  }

  /**
   * Transfers data from an input stream to an output stream.  Streams are 
   * closed after transfer completed.
   *
   * @parm in input stream
   * @parm out output stream
   */
  ///////////////////////////////////////////////
  private void transfer(InputStream in, OutputStream out) 
      throws FtpException, IOException {
    if (in == null)
      throw new IllegalArgumentException("null in");
    if (out == null)
      throw new IllegalArgumentException("null out");

    // buffer streams
    BufferedInputStream is = new BufferedInputStream(in);
    BufferedOutputStream os = new BufferedOutputStream(out);
    
    try {
      // perform transfer
      int b;
      while ((b = is.read()) != -1) {
        os.write(b);
      }
    }
    finally {
      // close streams
      is.close();
      os.close();
    }
  }

  ///////////////////////////////////////////////
  // PARSE REPLY
  ///////////////////////////////////////////////
  /**
   * Parses reply received from FTP Server. This is automatically executed 
   * by the FtpClient class after each command sent to the server.
   *
   * @see FtpReply
   */
  private void parseReply()
      throws FtpException, IOException {
    
    String replyText;
    d_reply = new FtpReply();

    try {
      // get first line
      replyText = d_cin.readLine();
    }
    catch (IOException e) {
      // socket no longer valid

      // manufacture reply
      d_reply.setReply(false, "421 Closing control channel");

      // display error
      if (isDebug()) 
        d_debugWriter.println(": IOException, closing connection.");
      try {
        close();
      }
      catch (IOException e2) {
        // ignore, throwing FtpException
      }

      // throw exception
      throw new FtpException(d_reply, "IOException");
    }

    try {
      // set reply as we know it (have replyText)
      d_reply.setReply(true, replyText);
      if (isDebug()) d_debugWriter.println("< " + replyText);
      
      // find last line of reply
      switch (replyText.charAt(3)) {
      default: // is an error
        throw new FtpException(d_reply);
      case ' ': // is last line
        break;
      case '-': // is first line
        // search for last line
        String key = replyText.substring(0,3) + ' ';
        while (!replyText.startsWith(key)) {
          replyText = d_cin.readLine();
          if (isDebug()) d_debugWriter.println("< " + replyText);
        }
        // set reply as we know it (have final replyText)
        d_reply.setReply(true, replyText);
        break;
      }
    }
    // catch exception thrown by new FtpReply()
    catch (IllegalArgumentException e) {
      throw new FtpException(d_reply, e.getMessage());
    }

    // failure reply?
    switch (d_reply.getType()) {
    case FtpReply.RC_ERROR:
    case FtpReply.RC_ERROR_TRANSIENT:
      throw new FtpException(d_reply);
    }
    
    // send interpretation to debug writer 
    if (isDebug()) {
      switch (d_reply.getCode()) {
      case 227: // passive mode server and port
        d_debugWriter.println(
          ": \"" + d_reply.getHost() + "\", " + 
          String.valueOf(d_reply.getPort()));
        break;
      case 257: // pathname 
        d_debugWriter.println(": \"" + d_reply.getPath() + '"');
        break;
      }
    }
  }

/////////////////////////////////////////////////
} // class FtpClient


