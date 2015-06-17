using Gtk;
using GLib;
using Notify;

public class Password : Window {

    /*private Entry search_entry;*/
    private ScrolledWindow bin;
    private TreeView view;
    private TreeIter iter;

    public Password (string password) {
        this.title = "Passwords";
        this.set_border_width (12);
        this.set_position (Gtk.WindowPosition.CENTER);
        this.set_default_size (625, 400);
        string[] passwords = get_passwords (password);
        setup_view (passwords);
        this.destroy.connect (Gtk.main_quit);
    }

    private string[] get_passwords (string password) {
        string p_stdout;
        string p_stderr;
        int p_status;
        GLib.Process.spawn_command_line_sync(
            "/home/nasonfish/Scripts/pswds.intermediate.bash " + GLib.Shell.quote(password), 
            out p_stdout, out p_stderr, out p_status);
        string[] services = p_stdout.split ("\\n");
        return services;
    }

    private void setup_view (string[] passwords) {
        /*this.search_entry = new Entry ();
        var search_label = new Label.with_mnemonic ("_Search for:");
        search_label.mnemonic_widget = this.search_entry;
        var hbox = new Box (Orientation.HORIZONTAL, 20);
        hbox.pack_start (search_label, false, true, 0);
        hbox.pack_start (this.search_entry, true, true, 0);
        this.add(hbox);*/
        
        this.bin = new ScrolledWindow (null, null);
        this.view = new TreeView ();
        this.view.set_enable_search (true);
        var listmodel = new Gtk.ListStore (2, typeof(string), typeof(string)); // name, password
        this.view.set_model(listmodel);
        this.view.insert_column_with_attributes (-1, "Name", new CellRendererText (), "text", 0);
        this.view.insert_column_with_attributes (-1, "Password", new CellRendererText (), "text", 1);
        foreach (string s in passwords){
            string[] parts = s.split(" ");
            listmodel.append (out iter);
            listmodel.set (iter, 0, parts[0].strip(), 1, parts[1].strip());
        }
        this.view.row_activated.connect((treeview, path, column) => {
            TreeIter current;
            if(treeview.model.get_iter (out current, path)) {
                string pwd;
                string name;
                treeview.model.get (current, 0, out name, 1, out pwd);
                Gdk.Display display = this.get_display ();
                Gtk.Clipboard clipboard = Gtk.Clipboard.get_for_display (display, Gdk.SELECTION_CLIPBOARD);
                clipboard.set_text (pwd, -1);
                Notify.init ("Password manager");
                try {
                    Notify.Notification notification = new Notify.Notification ("Password copied to clipboard",
                    "The password to " + name + " has been copied to your clipboard.", "dialog-information");
                    notification.show ();
                } catch (Error e) {}
            }
            /*TreeIter current;
            string val;
            this.view.get_iter (out current, path);
            this.view.get_value (current, 1, out val);
            stdout.printf ("%s\n", val);*/
        });
        bin.add (view);
        this.add (bin);
    }
}
