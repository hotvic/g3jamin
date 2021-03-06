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
using HV;


/* Pointer to Main Window */
public Ajami.MainWindow main_window;


namespace Ajami {
    public Limiter get_limiter_widget() {
        return main_window.get_limiter_widget();
    }

    public Spectrum get_spectrum_widget() {
        return main_window.get_spectrum_widget();
    }

    public Compressor? get_comp_widget(CompID id) {
        return main_window.get_comp_widget(id);
    }

    public enum MeterSide {
        L,
        R
    }

    [GtkTemplate (ui="/org/ajami/ajami/gtk/appwindow.ui")]
    public class MainWindow : ApplicationWindow {
        [GtkChild]
        private Scenes scenes;

        [GtkChild]
        private Limiter limiter;

        [GtkChild]
        private Spectrum spectrum;

        [GtkChild]
        private Compressor compressor_low;

        [GtkChild]
        private Compressor compressor_mid;

        [GtkChild]
        private Compressor compressor_high;

        [GtkChild]
        private Adjustment _in_gain_adj;

        [GtkChild]
        private Adjustment _in_balance_adj;

        [GtkChild]
        private Adjustment _out_gain_adj;

        [GtkChild]
        private Meter inmeter_l;

        [GtkChild]
        private Meter inmeter_r;

        [GtkChild]
        private Meter outmeter_l;

        [GtkChild]
        private Meter outmeter_r;

        [GtkChild]
        private Meter rmsmeter_l;

        [GtkChild]
        private Meter rmsmeter_r;

        [GtkChild]
        private Scale cross_low_scale;

        [GtkChild]
        private Scale cross_high_scale;

        [GtkChild]
        private GraphicEQ geq;

        [GtkChild]
        private Entry out_out_l_entry;
        [GtkChild]
        private Entry out_out_r_entry;
        [GtkChild]
        private Entry out_rms_l_entry;
        [GtkChild]
        private Entry out_rms_r_entry;

        [GtkChild]
        private Adjustment inmeter_l_adj;
        [GtkChild]
        private Adjustment inmeter_r_adj;
        [GtkChild]
        private Adjustment outmeter_l_adj;
        [GtkChild]
        private Adjustment outmeter_r_adj;
        [GtkChild]
        private Adjustment rmsmeter_l_adj;
        [GtkChild]
        private Adjustment rmsmeter_r_adj;

        [GtkChild]
        private Label cross_low_lbl;
        [GtkChild]
        private Label cross_high_lbl;

        public Scale low2mid_scale {
            get { return cross_low_scale; }
        }

        public Scale mid2high_scale {
            get { return cross_high_scale; }
        }

        public Adjustment in_gain_adj { get { return _in_gain_adj; } }

        public Adjustment in_balance_adj { get { return _in_balance_adj; } }

        public Adjustment out_gain_adj { get { return _out_gain_adj; } }

        public GraphicEQ w_geq {
            get { return geq; }
        }

        class construct
        {
            typeof(HV.Meter).ensure();
            typeof(GraphicEQ).ensure();
        }

        construct
        {
            w_scenes = scenes;
        }

        public MainWindow(Gtk.Application app) {
            Object(application: app);

            add_actions();
        }

        public override void show() {
            base.show();

            CAjami.HDEQ.crossover_init();
        }

        public Limiter get_limiter_widget() {
            return limiter;
        }

        public Spectrum get_spectrum_widget() {
            return spectrum;
        }

        public Compressor? get_comp_widget(CompID id) {
            switch (id) {
            case CompID.COMP_LOW:
                return compressor_low;
            case CompID.COMP_MID:
                return compressor_mid;
            case CompID.COMP_HIGH:
                return compressor_high;
            }

            return null;
        }

        public void add_actions() {
            var new_preset = new SimpleAction("new-preset", null);
            var open_preset = new SimpleAction("open-preset", null);
            var save_preset = new SimpleAction("save-preset", null);
            var save_as_preset = new SimpleAction("save-as-preset", null);
            var undo = new SimpleAction("undo", null);
            var redo = new SimpleAction("redo", null);

            this.add_action(new_preset);
            this.add_action(open_preset);
            this.add_action(save_preset);
            this.add_action(save_as_preset);
            this.add_action(undo);
            this.add_action(redo);
        }

        /* INTRIM */
        public void set_inmeter_value(MeterSide side, double value) {
            if (side == MeterSide.L) {
                this.inmeter_l_adj.value = value;
            } else {
                this.inmeter_r_adj.value = value;
            }
        }

        public void set_outmeter_value(MeterSide side, double value) {
            if (side == MeterSide.L) {
                this.outmeter_l_adj.value = value;
            } else {
                this.outmeter_r_adj.value = value;
            }
        }

        public void set_rmsmeter_value(MeterSide side, double value) {
            if (side == MeterSide.L) {
                this.rmsmeter_l_adj.value = value;
            } else {
                this.rmsmeter_r_adj.value = value;
            }
        }

        public void set_out_text(MeterSide side, string text) {
            if (side == MeterSide.L) {
                this.out_out_l_entry.set_text(text);
            } else {
                this.out_out_r_entry.set_text(text);
            }
        }

        public void set_rmsout_text(MeterSide side, string text) {
            if (side == MeterSide.L) {
                this.out_rms_l_entry.set_text(text);
            } else {
                this.out_rms_r_entry.set_text(text);
            }
        }

        public double get_inmeter_peak(MeterSide side) {
            if (side == MeterSide.L)
                return this.inmeter_l.peak;

            return this.inmeter_r.peak;
        }

        public double get_outmeter_peak(MeterSide side) {
            if (side == MeterSide.L)
                return this.outmeter_l.peak;

            return this.outmeter_r.peak;
        }

        public double get_rmsmeter_peak(MeterSide side) {
            if (side == MeterSide.L)
                return this.rmsmeter_l.peak;

            return this.rmsmeter_r.peak;
        }

        public void reset_inmeter_peak() {
            this.inmeter_l.reset_peak();
            this.inmeter_r.reset_peak();
        }

        public void reset_outmeter_peak() {
            this.outmeter_l.reset_peak();
            this.outmeter_r.reset_peak();
        }

        public void reset_rmsmeter_peak() {
            this.rmsmeter_l.reset_peak();
            this.rmsmeter_r.reset_peak();
        }

        public void set_inmeter_warn_point(double point)
        {
            inmeter_l.warn_point = point;
            inmeter_r.warn_point = point;
        }

        public void set_outmeter_warn_point(double point)
        {
            outmeter_l.warn_point = point;
            outmeter_r.warn_point = point;
        }

        public void set_rmsmeter_warn_point(double point)
        {
            rmsmeter_l.warn_point = point;
            rmsmeter_r.warn_point = point;
        }

        /* Crossover */
        public void set_cross_low_label(string label) {
            cross_low_lbl.label = label;
        }

        public void set_cross_high_label(string label) {
            cross_high_lbl.label = label;
        }

        [GtkCallback]
        public void in_gain_changed()
        {
            _state.set_value_ui(StateFlags.IN_GAIN, _in_gain_adj.value);
        }

        [GtkCallback]
        public void in_balance_changed()
        {
            _state.set_value_ui(StateFlags.IN_PAN, _in_balance_adj.value);
        }

        [GtkCallback]
        public void out_gain_changed()
        {
            _state.set_value_ui(StateFlags.OUT_GAIN, _out_gain_adj.value);
        }

        [GtkCallback]
        public void low2mid_changed()
        {
            CAjami.HDEQ.low2mid_set((Gtk.Range) cross_low_scale);
        }

        [GtkCallback]
        public void mid2high_changed()
        {
            CAjami.HDEQ.mid2high_set((Gtk.Range) cross_high_scale);
        }
    }
}
