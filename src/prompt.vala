using Gtk;

public class Prompt : Dialog {

    private Entry password_entry;
    private Widget submit_button;

    public Prompt () {
        this.title = "Enter Password";
        this.border_width = 5;
        this.set_default_size(350, 100);
        create_widgets ();
        create_signals ();
    }
    
    private void create_widgets () {
        this.password_entry = new Entry ();
        var password_label = new Label.with_mnemonic ("_Enter Password:");
        password_label.mnemonic_widget = this.password_entry;
        password_entry.set_visibility (false);

        var hbox = new Box (Orientation.HORIZONTAL, 20);
        hbox.pack_start (password_label, false, true, 0);
        hbox.pack_start (this.password_entry, true, true, 0);
        var content = this.get_content_area () as Box;
        content.pack_start (hbox, false, true, 0);
        add_button (Stock.HELP, ResponseType.HELP);
        add_button (Stock.CLOSE, ResponseType.CLOSE);
        this.submit_button = add_button (Stock.APPLY, ResponseType.APPLY);
        this.submit_button.sensitive = false;
        show_all();
    }
    
    private void create_signals () {
        this.password_entry.changed.connect (() => {
            this.submit_button.sensitive = (this.password_entry.text != "");
        });
        this.response.connect (on_response);
    }
    
    private void on_response (Dialog source, int response_id) {
        switch (response_id) {
        case ResponseType.HELP:
            break;
        case ResponseType.APPLY:
            on_submit_clicked ();
            break;
        case ResponseType.CLOSE:
            destroy();
            break;
        }
    }
    
    private void on_submit_clicked () {
        Password password = new Password (this.password_entry.text);
        this.destroy.disconnect (Gtk.main_quit);
        this.destroy ();
        password.destroy.connect (Gtk.main_quit);
        password.show_all ();
    }
    
    public static int main (string[] args) {
        Gtk.init (ref args);
        
        var prompt = new Prompt ();
        prompt.destroy.connect (Gtk.main_quit);
        prompt.show ();
        
        Gtk.main ();

        return 0;
    }
}
