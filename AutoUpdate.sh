#!/usr/bin/env bash

MSG=""

# --- Comprobar APT (.deb) ---
if command -v apt >/dev/null 2>&1; then
    sudo apt update >/dev/null 2>&1
    UPGRADABLE=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
    # if [ "$UPGRADABLE" -gt 0 ]; then
        MSG+=".DEB: $UPGRADABLE actualización pendiente.\n"
    # fi
fi

# --- Comprobar Flatpak ---
if command -v flatpak >/dev/null 2>&1; then
    # Quita líneas vacías y cuenta solo las que contengan un ID de app/runtime
    FUPDATES=$(flatpak remote-ls --updates 2>/dev/null | awk 'NF>0' | wc -l)
    # if [ "$FUPDATES" -gt 0 ]; then
        MSG+="FLATPAK $FUPDATES actualización pendiente.\n"
    # fi
fi

# --- Comprobar Snap ---
if command -v snap >/dev/null 2>&1; then
    # Lista solo los snaps que tienen actualización disponible
    SUPDATES=$(snap refresh --list 2>/dev/null | tail -n +2 | wc -l)
    # Si hay cabecera que no quieres contar, cambia tail -n +2
    #if [ "$SUPDATES" -gt 0 ]; then
        MSG+="SNAP $SUPDATES actualización pendiente.\n"
    #fi
fi

# --- Notificación si hay algo ---
#if [ -n "$MSG" ]; then
    notify-send "Actualizaciones disponibles" "$MSG"
#fi
