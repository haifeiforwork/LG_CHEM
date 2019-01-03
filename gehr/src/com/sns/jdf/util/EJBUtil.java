package com.sns.jdf.util;

import java.util.*;
import java.rmi.RemoteException;
import javax.rmi.PortableRemoteObject;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.ejb.CreateException;

import com.sns.jdf.*;

public final class EJBUtil {
    public static Object getEJBHomeInENC(String name, Class type) throws NamingException 
    {
        Hashtable env = new Hashtable();
        env.put("javax.naming.factory.initial","com.netscape.server.jndi.RootContextFactory");
        Logger.debug.println("EJBUtil create");
        InitialContext jndiContext = new InitialContext(env);
        Logger.debug.println("create InitialContext");
        Object ref = jndiContext.lookup("java:comp/env/" + name);
        Logger.debug.println("lookup");
        return javax.rmi.PortableRemoteObject.narrow(ref, type);
    }
}
