import { Component, OnInit } from '@angular/core';

import {Router, ActivatedRoute, Params} from '@angular/router';
import {FlashMessagesService} from 'angular2-flash-messages';

import {Settings} from '../../model/Settings';
import {SettingsService} from '../../services/settings.service';

@Component({
  selector: 'app-settings',
  templateUrl: './settings.component.html',
  styleUrls: ['./settings.component.css']
})
export class SettingsComponent implements OnInit {

	settings:Settings;

	constructor(
			  private router: Router,
			  private settingsService: SettingsService,
			  private flashMessage: FlashMessagesService		  
	  ) { }

  ngOnInit() {
	  this.settings= this.settingsService.getSettings();
  }

  onSubmit() {
	  this.settingsService.changeSettings(this.settings);
	  this.flashMessage.show("Settings Saved", {
		  cssClass:'alert-success',timeout:4000
	  });
  }
}
