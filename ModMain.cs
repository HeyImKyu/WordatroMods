using MelonLoader;
using UnityEngine;
using HarmonyLib;

namespace MyMelonMod
{
    public class ModMain : MelonMod
    {
        public override void OnApplicationStart()
        {
            MelonLogger.Msg("My Melon Mod has loaded!");
        }
    }

    [HarmonyPatch(typeof(Cases))]
    [HarmonyPatch("CheckValidity")]
    class Patch_CheckValidity
    {
        static Cases cachedInstance;

        static void Prefix(Cases __instance)
        {
            cachedInstance = __instance; // store instance for later use
            MelonLogger.Msg("CheckValidity is about to be called!");
        }

        static void Postfix()
        {
            MelonLogger.Msg("CheckValidity has been called.");
            MelonEvents.OnGUI.Subscribe(DrawText, 100);
            MelonEvents.OnGUI.Unsubscribe(DrawText);
        }

        public static void DrawText() {
            string textValue = GameObject.Find("Cases").GetComponent<Cases>().text;

            GUI.Label(new Rect(20, 20, 1000, 200), $"<b><color=cyan><size=100>Haiiii :3 {textValue}</size></color></b>");
            MelonLogger.Msg("text is: " + textValue);
        }
    }
}
