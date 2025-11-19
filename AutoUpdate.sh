#!/usr/bin/env bash

APT=0
FLATPAK=0
SNAP=0
MSG=""

# --- Comprobar APT (.deb) ---
if command -v apt >/dev/null 2>&1; then
    sudo /usr/bin/apt update -qq >/dev/null 2>&1
    APT=$(apt list --upgradable 2>/dev/null | tail -n +2 | wc -l)
    if [ "$APT" -gt 0 ]; then
        MSG+=".DEB: $APT actualizaciones pendientes.\n"
    fi
fi

# --- Comprobar Flatpak ---
if command -v flatpak >/dev/null 2>&1; then
    # Quita líneas vacías y cuenta solo las que contengan un ID de app/runtime
    FLATPAK=$(flatpak remote-ls --updates 2>/dev/null | awk 'NF>0' | wc -l)
    if [ "$FLATPAK" -gt 0 ]; then
        MSG+="FLATPAK $FLATPAK actualizaciones pendientes.\n"
    fi
fi

# --- Comprobar Snap ---
if command -v snap >/dev/null 2>&1; then
    # Lista solo los snaps que tienen actualización disponible
    SNAP=$(snap refresh --list 2>/dev/null | tail -n +2 | wc -l)
    # Si hay cabecera que no quieres contar, cambia tail -n +2
    if [ "$SNAP" -gt 0 ]; then
        MSG+="SNAP $SNAP actualizaciones pendientes.\n"
    fi
fi

TOTAL=$((APT + FLATPAK + SNAP))
notify-send "Actualizaciones: $TOTAL" "$MSG"