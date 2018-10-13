import { Component, OnInit } from '@angular/core';
import {Router, ActivatedRoute, Params} from '@angular/router';
import {FlashMessagesService} from 'angular2-flash-messages';

import {ClientService} from '../../services/client.service';
import {SettingsService} from '../../services/settings.service';
import {Client} from '../../model/Client';

@Component({
  selector: 'app-edit-client',
  templateUrl: './edit-client.component.html',
  styleUrls: ['./edit-client.component.css']
})
export class EditClientComponent implements OnInit {

  id:string;
  client: Client = {
	firstName:'',
	lastName:'',
	phone:'',
	email:'',
	balance:0
  };

  disableBalanceOnEdit:boolean;


  constructor(
		  private clientService: ClientService,
		  private router: Router,
		  private route: ActivatedRoute,
		  private settingsService: SettingsService,
		  private flashMessage: FlashMessagesService		  
  ) { }

  ngOnInit() {
	  this.disableBalanceOnEdit = this.settingsService.getSettings().disableBalanceOnEdit;
	  
	  this.id = this.route.snapshot.params['id'];
	  this.clientService.getClient(this.id).subscribe(client =>{
		  this.client = client;
		  
	  });
	  
  }
  
  onSubmit(submittedForm) {
	  if (!submittedForm.valid) {
		  this.flashMessage.show('Please fill out the form correctly', {
			  cssClass:'alert-danger', timeout:4000
		  });
	  }
	  else {
		  submittedForm.value.id=this.id;
		  this.clientService.updateClient(submittedForm.value);
		  this.flashMessage.show('Client Updated!', {
			  cssClass:'alert-success', timeout:4000
		  });
		  this.router.navigate(['/client/'+this.id]);
	  }
  }

}
