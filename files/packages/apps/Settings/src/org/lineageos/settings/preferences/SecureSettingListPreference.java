/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.lineageos.settings.preferences;

import android.content.Context;
import android.os.UserHandle;
import android.provider.Settings;
import android.util.AttributeSet;

import androidx.preference.ListPreference;

/**
 * A {@link ListPreference} that persists its value (parsed as an int) in
 * {@link Settings.Secure} under its own key, for the current user, instead
 * of SharedPreferences. Needed by the Display Engine preference, whose value
 * is read by system_server (Settings.Secure.DISPLAY_ENGINE_MODE).
 */
public class SecureSettingListPreference extends ListPreference {

    public SecureSettingListPreference(Context context, AttributeSet attrs, int defStyleAttr,
            int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    public SecureSettingListPreference(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public SecureSettingListPreference(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SecureSettingListPreference(Context context) {
        super(context);
    }

    @Override
    protected boolean persistString(String value) {
        if (value == null) {
            return false;
        }
        final int intValue;
        try {
            intValue = Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return false;
        }
        return Settings.Secure.putIntForUser(getContext().getContentResolver(), getKey(),
                intValue, UserHandle.USER_CURRENT);
    }

    @Override
    protected String getPersistedString(String defaultReturnValue) {
        final int defaultInt;
        try {
            defaultInt = defaultReturnValue != null ? Integer.parseInt(defaultReturnValue) : 0;
        } catch (NumberFormatException e) {
            return defaultReturnValue;
        }
        final int value = Settings.Secure.getIntForUser(getContext().getContentResolver(),
                getKey(), defaultInt, UserHandle.USER_CURRENT);
        return String.valueOf(value);
    }

}
