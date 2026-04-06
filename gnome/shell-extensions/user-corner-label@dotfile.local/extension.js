'use strict';

import Clutter from 'gi://Clutter';
import GLib from 'gi://GLib';
import St from 'gi://St';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

export default class UserCornerLabelExtension extends Extension {
    enable() {
        this._settings = this.getSettings();
        this._container = new St.BoxLayout({
            style_class: 'panel-status-menu-box',
            vertical: false,
        });

        this._icon = new St.Icon({
            icon_name: 'avatar-default-symbolic',
            style_class: 'system-status-icon',
        });

        this._label = new St.Label({
            y_align: Clutter.ActorAlign.CENTER,
        });

        this._container.add_child(this._icon);
        this._container.add_child(this._label);

        this._sync();
        this._settings.connectObject(
            'changed::display-text', () => this._sync(),
            'changed::show-icon', () => this._sync(),
            'changed::show-text', () => this._sync(),
            this,
        );

        Main.panel._leftBox.insert_child_at_index(this._container, 0);
    }

    disable() {
        this._settings.disconnectObject(this);
        this._container?.destroy();
        this._container = null;
        this._icon = null;
        this._label = null;
    }

    _sync() {
        const custom = this._settings.get_string('display-text').trim();
        const text = custom || GLib.get_user_name();
        const showIcon = this._settings.get_boolean('show-icon');
        const showText = this._settings.get_boolean('show-text');

        this._label.text = text;
        this._icon.visible = showIcon;
        this._label.visible = showText;
    }
}
