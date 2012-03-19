package  {
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	public class Contact_listener extends b2ContactListener {
		
		public var contact:Boolean = true;
		
		public override function BeginContact(contact:b2Contact):void {
			this.contact = true;
		}
		
		public override function EndContact(contact:b2Contact):void { 
			this.contact = false;
		}
		
	}

}