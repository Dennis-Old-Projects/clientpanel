import { Component, OnInit,ViewChild } from '@angular/core';
import { FlashMessagesService } from 'angular2-flash-messages';
import {Router} from '@angular/router';

import { Client } from '../../model/Client';
import {ClientService} from '../../services/client.service';
import {SettingsService} from '../../services/settings.service';

@Component({
	selector : 'app-add-client',
	templateUrl : './add-client.component.html',
	styleUrls : [ './add-client.component.css' ]
})
export class AddClientComponent implements OnInit {

	client: Client = {
		firstName : '',
		lastName : '',
		email : '',
		balance : 0
	};
	
	disableBalanceOnAdd = true;
	@ViewChild('clientForm') form: any;
	
	constructor(private flashMessage:FlashMessagesService,
			    private clientService: ClientService,
			    private settingsService: SettingsService,
			    private router: Router) {}
	
	ngOnInit() {
		this.disableBalanceOnAdd= this.settingsService.getSettings().disableBalanceOnAdd;
	}

	onSubmit(submittedForm) {
		if (this.disableBalanceOnAdd) {
			submittedForm.value.balance=0;
		}
		if (!submittedForm.valid) {
			this.flashMessage.show('Please fill out the form correctly',{
				cssClass: 'alert-danger',
				timeout: 4000
			});
		}
		else {
			this.clientService.newClient(submittedForm.value);
			this.flashMessage.show('New client added successfully',{
				cssClass: 'alert-success',
				timeout: 4000
			});
			this.router.navigate(['/']);
		}
	}
}