/*
 * Copyright (c) 2015 Victor A. Santos <victoraur.santos@gmail.com>
 *
 * This file is part of Ajami.
 *
 * Ajami is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Ajami is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Ajami.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;


/* C functions */
extern void preferences_init();


namespace Ajami
{
    public class Ajami : Gtk.Application
    {
        private uint _to_count = 1;

        public Ajami()
        {
            Object(application_id: "org.ajami.ajami", flags: 0);

            Environment.set_application_name("Ajami");

            add_actions();
        }

        public static Ajami get_app()
        {
            return GLib.Application.get_default() as Ajami;
        }

        public override void activate()
        {
            main_window.show_all();
            main_window.destroy.connect(() => {
                this.quit();
            });
        }

        public override void startup()
        {
            base.startup();

            main_window = new MainWindow(this);

            _state = new State();
            preferences_init();

            CAjami.GraphicEQ.bind();
            CAjami.HDEQ.bind();
            _intrim = new InTrim();
            _limiter = new LimiterBackend();
            CAjami.Compressor.bind();
            _stereo = new Stereo();

            _state.history_clear();

            CAjami.IO.activate();

            _state.load_preset("flat");

            Timeout.add(40, _intrim.update_meters);
        }

        public override void shutdown()
        {
            base.shutdown();

            CAjami.IO.cleanup();
        }

        public void add_actions()
        {
            var quit = new SimpleAction("quit", null);
            var preferences = new SimpleAction("preferences", null);

            preferences.activate.connect(act_preferences);

            quit.activate.connect(() => {
                this.quit();
            });

            this.add_action(quit);
            this.add_action(preferences);
        }

        public void act_preferences()
        {
            var prefs = new Preferences();

            prefs.show_all();
        }
    }
}
