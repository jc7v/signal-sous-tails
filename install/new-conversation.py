#!/usr/bin/env python3
import gi
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class DialogExample(Gtk.Dialog):
    def __init__(self, parent):
        super().__init__(title="Confirmation", transient_for=parent, flags=0)
        self.add_buttons(
            Gtk.STOCK_OK, Gtk.ResponseType.OK
        )

        self.set_default_size(150, 100)

        label = Gtk.Label(label="Le message devrait avoir été envoyé.\nPoursuis la conversation avec l'application Signal.\nN'oublie pas de paramétrer les messages éphémères.")

        box = self.get_content_area()
        box.add(label)
        self.show_all()

class NewConversation(Gtk.Window):

    def __init__(self):
        super().__init__(title="Commencer une nouvelle conversation")
        self.signal = 'torsocks /home/amnesia/Persistent/signal/signal-cli-0.10.11/bin/signal-cli'
        self.set_border_width(10)
        self.set_default_size(400, 100)
        self.vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(self.vbox)

        label = Gtk.Label()
        label.set_text("Entrer le numéro de téléphone")

        self.entry = Gtk.Entry()
        self.entry.set_text("")

        button = Gtk.Button.new_with_label("Nouvelle conversation")
        button.connect("clicked", self.on_click)

        self.spinner = Gtk.Spinner()

        self.vbox.pack_start(label, True, True, 0)
        self.vbox.pack_start(self.entry, True, True, 0)
        self.vbox.pack_start(button, True, True, 0)
        self.vbox.pack_start(self.spinner, True, True, 0)

    def on_click(self, button):
        if self.entry.get_text() == "":
            return
        self.spinner.start()
        os.system(self.signal + ' send -m "salut" ' + self.entry.get_text())
        dialog = DialogExample(self)
        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            self.entry.set_text("")    
            self.spinner.stop()
        dialog.destroy()

win = NewConversation()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
