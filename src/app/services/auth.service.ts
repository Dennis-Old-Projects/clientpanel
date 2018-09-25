import { Injectable } from '@angular/core';

import {AngularFireAuth} from 'angularfire2/auth';
import { Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  authState: any = null;
  constructor(private afAuth:AngularFireAuth ) { }
  
  login(email:string, password:string) {
	  console.log(email);
	  return new Promise((resolve, reject) => {
		  this.afAuth.auth.signInWithEmailAndPassword(email,password)
		  	.then(userData => {
		  		resolve(userData);
		  		this.authState = userData;
		  	  },err => reject(err));
	  });
  }
  
  getAuth() {
	  return this.authState;
  }
}
