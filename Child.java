/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package scheduler;

/**
 *
 * @author appdev2
 */
    
    
    public class Child extends parent
{
        @Override
	public void disp()
	{
		System.out.println("Child disp called");
	}
	public static void main(String args[])
	{
                parent pa = new parent();
		Child p = new Child();
		p.disp();
                pa.disp();  
                pa = p;
                pa.disp();
		Child c = (Child)pa;
                c.disp();
               // pat.disp();
              //  Child cv = (Child)p;
              //  pa.disp();
                
             printing("Holla!!!");  
             
             int mine = 100;
             
             printing("You are " + mine);
                
	}
        
        static void printing(Object obj){
         
            System.out.println(obj);
        }
}
